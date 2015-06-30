module ControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  def login_user(u=nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    u =if u.nil?
      FactoryGirl.create(:user)
    elsif u.kind_of?(Symbol)
      FactoryGirl.create(u)
    else
      u
    end
    sign_out :user
    sign_in(u)
    @current_user = u
  end

  module ClassMethods

    def it_should_require_signed_in_user(actions, resource_name)
      get_actions_hash(actions).each do |action, verb|
        it "#{action} action should redirect to signing in page if user IS NOT signed in" do
          sign_out(:user)
          process(action, verb.to_s.upcase, {:id => create(resource_name), resource_name => {something: 'something'}} , nil, nil)
          begin
            json_response = JSON.parse(response.body)
            expect(json_response["error_code"]).to eq(403)
          rescue JSON::ParserError
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end
    end

    def it_only_allows_admin(actions, resource_name)
      get_actions_hash(actions).each do |action, verb|

        it "#{action} action renders 403 page if user is NOT admin" do
          login_user
          process(action, verb.to_s.upcase, {:id => create(resource_name), resource_name => {something: 'something'}} , nil, nil)
          begin
            json_response = JSON.parse(response.body)
            expect(json_response["error_code"]).to eq(403)
          rescue JSON::ParserError
            expect(response).to render_403
          end
        end

        it "#{action} action DOESN'T render 403 page if user is admin" do
          login_user(FactoryGirl.create(:admin))
          begin
            process(action, verb.to_s.upcase, {:id => create(resource_name), resource_name => attributes_for(resource_name)} , nil, nil)
          rescue ActiveRecord::RecordNotFound
          end
          expect(response).to_not render_403
        end

      end
    end

    def it_should_render_404_if_the_resource_was_not_found(actions, options={})
      get_actions_hash(actions).each do |action, verb|
        it "#{action} (#{verb.to_s.upcase}) action should render 404 if the resource was not found" do
          login_user(FactoryGirl.create(options[:with] || :user))
          yield(@current_user) if block_given?
          begin
            process(action, verb.to_s.upcase, {:id => 0} , nil, nil)
          rescue ActiveRecord::RecordNotFound
            record_not_found = true
          end
          expect(response).to render_404 unless record_not_found
        end
      end
    end

    def it_only_allows_resource_author_or_admin(actions, model_name, user_factory=:user, code: 403)

      get_actions_hash(actions).each do |action, verb|

        it "#{action} action renders 403 page if user is NOT admin or the resource author" do
          login_user
          process(action, verb.to_s.upcase, {:id => FactoryGirl.create(model_name)} , nil, nil)
          begin
            json_response = JSON.parse(response.body)
            expect(json_response["error_code"]).to eq(code)
          rescue JSON::ParserError
            expect(response).to send("render_#{code}")
          end
        end

        it "#{action} action DOESN'T render 403 page if user is an admin" do
          login_user(FactoryGirl.create(:admin))
          begin
            process(action, verb.to_s.upcase, {:id => 0} , nil, nil)
          rescue ActiveRecord::RecordNotFound
          end
          expect(response).to_not render_403
        end

        it "#{action} action DOESN'T render 403 page if user is the author of the resource" do
          if !user_factory
            login_user FactoryGirl.create(model_name)
          else
            resource = FactoryGirl.create(model_name, user: FactoryGirl.create(user_factory))
            login_user(resource.user)
          end
          begin
            process(action, verb.to_s.upcase, {:id => 0} , nil, nil)
          rescue ActiveRecord::RecordNotFound
          end
          expect(response).to_not render_403
        end

      end

    end

    private

      def get_actions_hash(actions)
        if actions.kind_of?(Array)
          new_actions = {}
          actions.each do |a|

            if a.kind_of?(Array)
              new_actions[a[0]] = a[1]
            else
              case a
                when :create
                  new_actions[a] = :post
                when :update
                  new_actions[a] = :put
                when :destroy
                  new_actions[a] = :delete
                else
                  new_actions[a] = :get
              end
            end
          end
          return new_actions
        else
          return actions
        end
      end

  end

end
