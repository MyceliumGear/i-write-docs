module ApplicationHelper

  def gateway_id_for_order(o)
    if @gateways
      @gateways.each { |g| return g.id if o.gateway_id == g.straight_gateway_id }
    end
    nil
  end

end
