class ReferralRouter
  def initialize(message)
    @message = message
  end

  def perform
    token = @message.ref
    if token.present?
      user = find_user token
      if user.fb_chat_id.blank?
        user_by_chat_id = User.where(fb_chat_id: @message.sender['id']).first
        if user_by_chat_id.present?
          if user.parent_id.blank?
            user.link_to(parent: user_by_chat_id)
          elsif user.parent_id != user_by_chat_id.id
            fail "user mismatch error, user.parent_id(#{user.parent_id})!=user_by_chat_id.id(#{user_by_chat_id.id})"
          else
            # its already linked nothing to do
          end
        elsif user.parent_id.present?
          fail "database inconsistency, user.parent_id(#{user.parent_id}) set, but parent was not found by fb_chat_id(#{@message.sender['id']})"
        else
          fb_data = Koala::Facebook::API.new(ENV['facebook_page_access_token']).get_object("#{@message.sender['id']}?fields=first_name,last_name,profile_pic")
          user_by_pic = User.where(image_url: fb_data['profile_pic']).first
          if user_by_pic.present?
            update_user(user_by_pic, fb_data)
            user.link_to(parent: user_by_pic)
          else
            update_user(user, fb_data)
          end
        end
      end
      Redis.new.publish "user_#{user.id}", {account_linked: true}.to_json
    end
  end

  private

  def find_user(token)
    sleep(rand(200) / 1000.0)
    User.where(authentication_token: token).first
  end

  def link_to_parent(user, parent)
    user.update!(parent_id: parent.id)
  end

  def update_user(user, fb_data)
    user.update!(
        fb_chat_id: @message.sender['id'],
        name: "#{fb_data['first_name']} #{fb_data['last_name']}",
        image_url: fb_data['profile_pic']
    )
  end
end
