require 'rails_helper'

RSpec.describe AddressProvidersController, type: :controller do

  it_should_require_signed_in_user [:index, :show, :new, :create, :edit, :update], :cashila_address_provider
  it_should_render_404_if_the_resource_was_not_found [:show, :edit, :update]
  it_only_allows_resource_author_or_admin [:show, :edit, :update], :cashila_address_provider, code: 404

  describe "index action" do
    it "redirects to #new if collection is empty" do
      login_user
      get :index
      expect(response.headers['Location']).to end_with '/exchanges/new'
    end

    it "paginates and scopes records by current user or shows all records to admin" do
      @users     = [create(:user), create(:user), create(:admin)]
      @providers = @users.map { |user| create(:cashila_address_provider, user: user) }

      login_user @users[0]
      get :index
      expect(assigns(:address_providers).ids).to eq [@providers[0].id]

      login_user @users[1]
      get :index
      expect(assigns(:address_providers).ids).to eq [@providers[1].id]
      expect(assigns(:address_providers).current_page).to eq 1
      expect(assigns(:address_providers).per_page).to eq 30

      login_user @users[2]
      get :index
      expect(assigns(:address_providers).ids.sort).to eq @providers.map(&:id)
      expect(assigns(:address_providers).current_page).to eq 1
      expect(assigns(:address_providers).per_page).to eq 30
    end
  end

  describe "show action" do

    context "Cashila" do

      it "fetches user info" do
        login_user
        stub_request(:get, 'https://cashila-staging.com/api/v1/verification').
          to_return(status: 200, body: '{"status":"pending"}')
        get :show, id: create(:cashila_address_provider, user: @current_user).id
        expect(assigns(:actual_state)).to eq('status' => 'pending')
      end
    end
  end

  describe "new action" do

    it "renders forms" do
      login_user
      get :new
      expect(response).to render_template(:new)
      expect(response.status).to eq 200
    end
  end

  describe "create action" do

    it "redirects to index if type is invalid" do
      login_user
      expect {
        post :create, type: 'hacked'
      }.to change { AddressProvider.count }.by 0
      expect(response.headers['Location']).to end_with '/exchanges'
    end

    context "Cashila" do

      it "creates address provider with docs, only one of this type" do
        login_user
        @current_user.update_column :email, 'alerticus+spam2@gmail.com'
        VCR.use_cassette 'address_providers_cashila_create_with_docs' do
          expect {
            post :create, type: 'Cashila', address_providers_cashila: {user_details: build(:cashila_user_details), files: build(:cashila_files)}
          }.to change { AddressProvider.count }.by 1
        end
        expect(@current_user.address_providers.count).to eq 1
        @cashila = @current_user.address_providers[0]
        expect(@cashila).to be_kind_of AddressProviders::Cashila
        expect(@cashila.recipient_id).to be_nil
        expect(response.headers['Location']).to end_with "/exchanges/#{@current_user.address_providers.ids[0]}"

        expect {
          post :create, type: 'Cashila', address_providers_cashila: {user_details: {}}
        }.to change { AddressProvider.count }.by 0
        expect(assigns(:address_provider).errors.messages).to eq(type: ["exchange of this type is already present"])
        expect(response).to render_template(:new)
      end

      it "creates address provider with recipient" do
        login_user
        @current_user.update_column :email, 'alerticus+spam3@gmail.com'
        details = build(:cashila_user_details)
        details.merge! build(:cashila_recipient_details)
        VCR.use_cassette 'address_providers_cashila_create_with_recipient' do
          expect {
            post :create, type: 'Cashila', address_providers_cashila: {user_details: details}
          }.to change { AddressProvider.count }.by 1
        end
        expect(@current_user.address_providers.count).to eq 1
        @cashila = @current_user.address_providers[0]
        expect(@cashila).to be_kind_of AddressProviders::Cashila
        expect(@cashila.recipient_id).to be_present
        expect(response.headers['Location']).to end_with "/exchanges/#{@current_user.address_providers.ids[0]}"
      end

      it "does not create invalid address provider" do
        login_user
        @current_user.update_column :email, 'example@example.com' # invalid
        VCR.use_cassette 'address_providers_cashila_create_invalid' do
          expect {
            post :create, type: 'Cashila', address_providers_cashila: {user_details: build(:cashila_user_details)}
          }.to change { AddressProvider.count }.by 0
        end
        expect(response).to render_template(:new)
      end

      it "creates address provider without invalid recipient and allows to edit it" do
        login_user
        @current_user.update_column :email, 'alerticus+spam4@gmail.com'
        details = build(:cashila_user_details)
        details.merge! build(:cashila_recipient_details)
        details.delete :recipient_iban # invalid
        VCR.use_cassette 'address_providers_cashila_create_with_invalid_recipient' do
          expect {
            post :create, type: 'Cashila', address_providers_cashila: {user_details: details}
          }.to change { AddressProvider.count }.by 1
        end
        expect(@current_user.address_providers.count).to eq 1
        @cashila = @current_user.address_providers[0]
        expect(@cashila).to be_kind_of AddressProviders::Cashila
        expect(@cashila.recipient_id).to be_nil
        expect(response).to render_template(:edit)

        details.merge! build(:cashila_recipient_details)
        VCR.use_cassette 'address_providers_cashila_create_recipient' do
          expect {
            post :update, id: @cashila.id, address_providers_cashila: {user_details: details}
          }.to change { AddressProvider.count }.by 0
        end
        @recipient_id = @cashila.reload.recipient_id
        expect(@recipient_id).to be_present

        details[:recipient_name] = 'changed name'
        VCR.use_cassette 'address_providers_cashila_update_recipient' do
          expect {
            post :update, id: @cashila.id, address_providers_cashila: {user_details: details}
          }.to change { AddressProvider.count }.by 0
        end
        @cashila.reload
        expect(@cashila.recipient_id).to eq @recipient_id
        expect(@cashila.recipient_name).to eq 'changed name'
      end
    end
  end
end
