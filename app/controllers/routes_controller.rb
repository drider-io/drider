class RoutesController < ApplicationController
  before_action :user_required

  def new
    @route = CarRoute.new
    render '_form'
  end

  def create
    data = JSON.parse(params[:data])
    polyline = params[:polyline]
    sql =<<SQL
INSERT INTO car_routes (user_id, created_at, updated_at, route, started_at, finished_at, from_address, to_address, driven_at, payload) VALUES( $1, $2, $2, ST_Transform(ST_LineFromEncodedPolyline($3),3857), $4, $5, $6, $7, $4, $8 ) RETURNING id::text
SQL
    result = ActiveRecord::Base.connection.exec_query(sql,'SQL', [
      [nil, current_user.id],
      [nil, Time.now],
      [nil, polyline],
      [nil, Time.now],
      [nil, Time.now],
      [nil, data[0]['text']],
      [nil, data[-1]['text']],
      [nil, {data: data}.to_json]
    ]
    ).first
    render json: {}
  end

  def show
    @route = current_user.car_routes.find(params[:id])
    render '_form'
  end

  def update
    data = JSON.parse(params[:data])
    id = params[:id]
    polyline = params[:polyline]
    sql =<<SQL
UPDATE car_routes SET updated_at=$3, route=ST_Transform(ST_LineFromEncodedPolyline($4),3857), from_address=$5, to_address=$6, payload=$7 WHERE id=$2 and user_id=$1 RETURNING id::text
SQL
    result = ActiveRecord::Base.connection.exec_query(sql,'SQL', [
      [nil, current_user.id],
      [nil, id],
      [nil, Time.now],
      [nil, polyline],
      [nil, data[0]['text']],
      [nil, data[-1]['text']],
      [nil, {data: data}.to_json]
    ]
    ).first
    render json: {}
  end
end
