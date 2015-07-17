class MessagesController < ApplicationController
  # before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :user_required

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.index(current_user)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @correspondent = User.find(params[:id])
    @messages = Message.conversation(@correspondent, current_user)
    @last_request_messages_id = @messages.group_by{|m| m.car_request_id}.map{|k,v| v.max_by{|e| e.id}}.map(&:id)
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
