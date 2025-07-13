module UsersHelper
  def format_duration(seconds)
    return "0s" if seconds.nil? || seconds == 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    if hours > 0
      "#{hours.to_i}h #{minutes.to_i}m #{secs.to_i}s"
    elsif minutes > 0
      "#{minutes.to_i}m #{secs.to_i}s"
    else
      "#{secs.to_i}s"
    end
  end
end
