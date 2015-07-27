class MessagesController < ApplicationController
  layout 'account'
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
    @messages = Message.conversation(@correspondent, current_user).order('id DESC').limit(30).reverse
    redirect_to messages_url and return if @messages.empty? #protection from information disclosure
    @messages_by_date = @messages.group_by {|m| m.created_at.to_date}
    mark_messages_as_read
  end

  # POST /messages
  # POST /messages.json
  def create
    correspondent = User.find(params[:to_id])
    redirect_to messages_url and return if Message.conversation(correspondent, current_user).first.blank?
    redirect_to message_url(correspondent.id) and return if params[:body].blank?
    msg = Message.create(from: current_user, to: correspondent, body: params[:body])
    redirect_to message_url(correspondent.id)
  end


  def mark_messages_as_read
    to_update = @messages.to_a.select{|m| m.delivery_status != 'read' && m.to_id == current_user.id}
    Message.where(id: to_update).update_all(delivery_status: 'read') if to_update.present?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_message
    #   @message = Message.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def message_params
    #   params.require(:message).permit(:from, :to, :car_request, :body, :seen_at)
    # end
end
