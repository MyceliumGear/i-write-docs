module ApplicationHelper

  def gateway_id_for_order(o)
    @gateways.each { |g| return g.id if o.gateway_id == g.straight_gateway_id }
    nil
  end

end
