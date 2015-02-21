RSpec::Matchers.define :render_403 do

  match { |r| r.status == 403 }

  failure_message do |actual|
    "expected that it rendered 403 page, but it didn't"
  end
  failure_message_when_negated do |actual|
    "expected that it wouldn't render 403 page, but it did"
  end

end

RSpec::Matchers.define :render_404 do

  match { |r| r.status == 404 }

  failure_message do |actual|
    "expected that it rendered 404 page, but it didn't"
  end
  failure_message_when_negated do |actual|
    "expected that it wouldn't render 404 page, but it did"
  end

end

RSpec::Matchers.define :render_json_with do |hash|
  match do |r|
    json_response = JSON.parse(r.body)
    hash.each do |k,v|
      if v == :anything
        expect(json_response[k.to_s]).to_not be_nil
      elsif v == nil
        expect(json_response[k.to_s]).to be_nil
      else
        expect(json_response[k.to_s]).to eq(v)
      end
    end
  end

  failure_message do |actual|
    "expected that it had:\n\n\t\t#{hash},\n\nbut instead it had:\n\n\t\t#{actual.body}"
  end
  failure_message_when_negated do |actual|
    "expected that it wouldn't render #{hash.inspect} but it did!"
  end

end
