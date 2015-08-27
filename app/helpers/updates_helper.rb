module UpdatesHelper
  def priority_indicator(item)
    case item.priority
      when 'regular'
        return
      when 'important'
        return 'orange'
      when 'critical'
        return 'red'
    end
  end
end
