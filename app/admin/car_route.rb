ActiveAdmin.register CarRoute do
  config.filters = false
  actions :index, :show, :destroy
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  collection_action :generate_route, method: :get do
    processor = LocationsProcessor.new
    processor.perform
    redirect_to collection_path, notice: processor.get_log
  end

  action_item :view do
    link_to 'Process Locations', generate_route_admin_car_routes_path
  end

  index do
    selectable_column
    id_column
    column :user
    column :from_address
    column :to_address
    column :started_at
    column :finished_at
    column :sessions do |route|
      route.car_sessions.count
    end
    column :locations_count do |route|
      route.car_sessions.present? &&
      route.car_sessions.first.car_locations.count
    end
    actions
  end
  show do
    render 'route'
  end

end
