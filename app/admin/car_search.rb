ActiveAdmin.register CarSearch do
  config.filters = false
  actions :index, :show

  index do
    selectable_column
    id_column
    column :user
    column :from_title
    column :to_title
    actions
  end

  show do |search|
    attributes_table do
      row :id
      row :user
      row :from_title
      row :to_title
      render 'show'
    end
  end
end
