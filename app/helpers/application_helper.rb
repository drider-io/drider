module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, self.output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def format_tiny_time(time)
    days = time.to_f/1.day.to_i
    if days>1
      "#{days.round}д"
    else
      hours = time.to_f/1.hour.to_i
      if hours>1
        "#{hours.round}ч"
      else
        mins = time.to_f/1.minute.to_i
        if mins>1
          "#{mins.round}м"
        else
          "#{time.to_i}с"
        end
      end
    end
  end

  def tiny_time_from_now(time)
    format_tiny_time(Time.now - time)
  end

  def mobile_app?
    session[:client].in? ['ios', 'android']
  end
end
