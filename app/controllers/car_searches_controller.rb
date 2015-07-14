class CarSearchesController < ApplicationController
  before_action :set_car_search, only: [:show, :edit, :update, :destroy]

  # GET /car_searches
  # GET /car_searches.json
  def index
    @car_searches = CarSearch.all
    p
  end

  # GET /car_searches/1
  # GET /car_searches/1.json
  def show
    @routes = CarRouteSearcher.new.search(@car_search)
    @from_marker = @car_search.from_g
    @to_marker = @car_search.to_g


    @map_data_url = car_search_url(@car_search, format: :json)
    respond_to do |format|
      format.html
      format.json { render :json => CarSearchResultSerializer.new(@routes) }
    end
  end

  # GET /car_searches/new
  def new
    @car_search = CarSearch.new
  end

  # POST /car_searches
  # POST /car_searches.json
  def create
    @car_search = CarSearch.new(car_search_params)

    respond_to do |format|
      if @car_search.save
        format.html { redirect_to @car_search }
        format.json { render :show, status: :created, location: @car_search }
      else
        format.html { render :new }
        format.json { render json: @car_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_searches/1
  # PATCH/PUT /car_searches/1.json
  def update
    respond_to do |format|
      if @car_search.update(car_search_params)
        format.html { redirect_to @car_search, notice: 'Car search was successfully updated.' }
        format.json { render :show, status: :ok, location: @car_search }
      else
        format.html { render :edit }
        format.json { render json: @car_search.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_search
      @car_search = CarSearch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_search_params
      params.require(:car_search).permit(:scheduled_to, :from_title, :to_title, :from_g, :to_g, :pinned)
      .tap{|params| params[:user] = current_user}
    end
end
