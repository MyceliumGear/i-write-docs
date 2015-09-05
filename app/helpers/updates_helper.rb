module UpdatesHelper
  def priority_indicator(item)
    case item.priority
    when 'important' then 'orange'
    when 'critical'  then 'red'
    else ''
    end
  end
end
