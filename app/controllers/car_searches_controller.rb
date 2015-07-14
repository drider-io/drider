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
    @from_marker = GeoLocation.new.to_g(@car_search.from_m)
    @to_marker = GeoLocation.new.to_g(@car_search.to_m)


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
      search_params = params.require(:car_search)
      search_params.permit(:scheduled_to, :pinned)
      .tap{|params|
        params[:user] = current_user
        from_m = GeoLocation.new.str_to_m(search_params[:from])
        to_m = GeoLocation.new.str_to_m(search_params[:to])
        if from_m
          params[:from_m] = from_m
          params[:from_title] = GeoLocation.new(location: from_m).address
        else
          params[:from_title] = search_params[:from]
          params[:from_m] = GeoLocation.new(address: search_params[:from]).m
        end

        if to_m
          params[:to_m] = to_m
          params[:to_title] = GeoLocation.new(location: to_m).address
        else
          params[:to_title] = search_params[:to]
          params[:to_m] = GeoLocation.new(address: search_params[:to]).m
        end
      }
    end

end
