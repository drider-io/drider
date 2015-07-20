class CarRequestsController < ApplicationController
  layout 'account'
  before_action :set_car_request, only: [:edit, :update, :destroy]
  before_action :user_required
  before_action { menu_set_active('requests') }

  # GET /car_requests
  # GET /car_requests.json
  def index
    @car_requests = CarRequest.with_user(current_user)
  end

  # GET /car_requests/new
  def new
    @car_request = CarRequest.new
  end

  # GET /car_requests/1/edit
  def edit
  end

  # POST /car_requests
  # POST /car_requests.json
  def create
    @car_request = CarRequest.new(car_request_params)
    respond_to do |format|
      if @car_request.save
        format.html { redirect_to car_requests_url, notice: 'Car request was successfully created.' }
        format.json { render :show, status: :created, location: @car_request }
      else
        format.html { redirect_to new_car_search, notice: 'car request failed'}
        format.json { render json: @car_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_requests/1
  # PATCH/PUT /car_requests/1.json
  def update
    redirect_to :root and return unless @car_request.aasm.events.map(&:name).map(&:to_s).include? params[:form_action]
    @car_request.send(params[:form_action], nil, current_user)
    @car_request.save!
    redirect_to car_requests_url
  end

  # DELETE /car_requests/1
  # DELETE /car_requests/1.json
  def destroy
    @car_request.destroy
    respond_to do |format|
      format.html { redirect_to car_requests_url, notice: 'Car request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_request
      @car_request = CarRequest.with_user(current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_request_params
      params.permit(:scheduled_to, :pickup_address, :drop_address, )
      .tap { |p|
        p[:pickup_location] = GeoLocation.new.str_to_m(params[:pickup_location])
        p[:drop_location] = GeoLocation.new.str_to_m(params[:drop_location])
        p[:passenger] = current_user
        p[:car_route] = CarRoute.find(params[:car_route_id])
        p[:driver_id] = p[:car_route].user_id
        p[:status] = 'sent'
      }
    end
end
