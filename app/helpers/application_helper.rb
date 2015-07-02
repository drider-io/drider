module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, self.output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
end
