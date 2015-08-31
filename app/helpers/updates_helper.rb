module UpdatesHelper
  def priority_indicator(item)
    case item.priority
    when 'regular' then return
    when 'important' then return 'orange'
    when 'critical' then return 'red'
    end
  end
end
