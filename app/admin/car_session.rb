ActiveAdmin.register CarSession do
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
    link_to 'Process Locations', generate_route_admin_car_sessions_path
  end


  index do
    selectable_column
    id_column
    column :user
    column :from_address
    column :created_at
    column :locations_count do |session|
      session.car_locations.count
    end
    actions
  end
  show do
    render 'route'
  end

end
