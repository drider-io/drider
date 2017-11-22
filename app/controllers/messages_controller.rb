class MessagesController < ApplicationController
  layout 'amp'
  # before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :user_required
  before_action { menu_set_active('messages') }
  # after_action :mark_messages_as_read, only: [:show]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.index(current_user)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @correspondent = User.find(params[:id])
    @structed_messages = structed_messages
    respond_to do |format|
      format.html {
        mark_messages_as_read
        @template = render_to_string partial: 'messages.html.mustache'
      }
      format.json do
        result= {}
        if params[:cmt_id].to_i == @correspondent.id
          mark_messages_as_read
          result[:messages_html] = render_to_string(partial: 'messages', formats: :html)
        end
        result[:urc] = unread_requests_count
        result[:umc] = unread_messages_count
        result[:ut] = result[:urc] + result[:umc]
        render json: result
      end
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @correspondent = User.find(params[:to_id])
    if params[:body].present?
      msg = Message.create!(from: current_user, to: @correspondent, body: params[:body])
      MessageNotifier.new(@correspondent).perform
    end
    render json: { messages: structed_messages }
  end


  def mark_messages_as_read
    to_update = @messages.to_a.select{|m| m.delivery_status != 'read' && m.to_id == current_user.id}
    Message.where(id: to_update).update_all(delivery_status: 'read') if to_update.present?
  end

  private

  def messages_for_correspondent
    Message.conversation(@correspondent, current_user).order('id DESC').limit(30).reverse
  end


  def structed_messages
    messages = Message.conversation(@correspondent, current_user).order('id DESC').limit(30).reverse
    grouped = messages.group_by {|m| m.created_at.to_date}
    grouped.keys.sort.reverse.each_with_index.map do |date, i|
      messages = grouped[date].sort_by(&:created_at).reverse.map {|m|
        r = {
          body: m.body,
          created_at: m.created_at.to_formatted_s(:time)
        }
        r[:className] = ' mymessage' if m.from_id == current_user.id
        r
      }
      if i>0
        {
          date: date,
          messages: messages
        }
      else
        {
          messages: messages
        }
      end
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    # def set_message
    #   @message = Message.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def message_params
    #   params.require(:message).permit(:from, :to, :car_request, :body, :seen_at)
    # end
end
