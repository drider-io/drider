class CarRequestsController < ApplicationController
  layout 'account'
  before_action :set_car_request, only: [:show, :edit, :update, :destroy]

  # GET /car_requests
  # GET /car_requests.json
  def index
    @car_requests = CarRequest.all
  end

  # POST /car_requests
  # POST /car_requests.json
  def create
    @car_request = CarRequest.new(car_request_params)

    respond_to do |format|
      if @car_request.save
        format.html { redirect_to @car_request, notice: 'Car request was successfully created.' }
        format.json { render :show, status: :created, location: @car_request }
      else
        format.html { render :new }
        format.json { render json: @car_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_requests/1
  # PATCH/PUT /car_requests/1.json
  def update
    respond_to do |format|
      if @car_request.update(car_request_params)
        format.html { redirect_to @car_request, notice: 'Car request was successfully updated.' }
        format.json { render :show, status: :ok, location: @car_request }
      else
        format.html { render :edit }
        format.json { render json: @car_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_request
      @car_request = CarRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_request_params
      params.permit(:scheduled_to, :pickup_location, :drop_location, :pickup_address, :drop_address)
    end
end
