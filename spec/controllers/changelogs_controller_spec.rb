require 'rails_helper'

describe ChangelogsController, type: :controller do

  # describe "GET #index" do
  #   it "assigns all changelogs as @changelogs" do
  #     changelog = Changelog.create! valid_attributes
  #     get :index, {}, valid_session
  #     expect(assigns(:changelogs)).to eq([changelog])
  #   end
  # end
  #
  # describe "GET #show" do
  #   it "assigns the requested changelog as @changelog" do
  #     changelog = Changelog.create! valid_attributes
  #     get :show, {:id => changelog.to_param}, valid_session
  #     expect(assigns(:changelog)).to eq(changelog)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new changelog as @changelog" do
  #     get :new, {}, valid_session
  #     expect(assigns(:changelog)).to be_a_new(Changelog)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested changelog as @changelog" do
  #     changelog = Changelog.create! valid_attributes
  #     get :edit, {:id => changelog.to_param}, valid_session
  #     expect(assigns(:changelog)).to eq(changelog)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Changelog" do
  #       expect {
  #         post :create, {:changelog => valid_attributes}, valid_session
  #       }.to change(Changelog, :count).by(1)
  #     end
  #
  #     it "assigns a newly created changelog as @changelog" do
  #       post :create, {:changelog => valid_attributes}, valid_session
  #       expect(assigns(:changelog)).to be_a(Changelog)
  #       expect(assigns(:changelog)).to be_persisted
  #     end
  #
  #     it "redirects to the created changelog" do
  #       post :create, {:changelog => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Changelog.last)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved changelog as @changelog" do
  #       post :create, {:changelog => invalid_attributes}, valid_session
  #       expect(assigns(:changelog)).to be_a_new(Changelog)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, {:changelog => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested changelog" do
  #       changelog = Changelog.create! valid_attributes
  #       put :update, {:id => changelog.to_param, :changelog => new_attributes}, valid_session
  #       changelog.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested changelog as @changelog" do
  #       changelog = Changelog.create! valid_attributes
  #       put :update, {:id => changelog.to_param, :changelog => valid_attributes}, valid_session
  #       expect(assigns(:changelog)).to eq(changelog)
  #     end
  #
  #     it "redirects to the changelog" do
  #       changelog = Changelog.create! valid_attributes
  #       put :update, {:id => changelog.to_param, :changelog => valid_attributes}, valid_session
  #       expect(response).to redirect_to(changelog)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the changelog as @changelog" do
  #       changelog = Changelog.create! valid_attributes
  #       put :update, {:id => changelog.to_param, :changelog => invalid_attributes}, valid_session
  #       expect(assigns(:changelog)).to eq(changelog)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       changelog = Changelog.create! valid_attributes
  #       put :update, {:id => changelog.to_param, :changelog => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested changelog" do
  #     changelog = Changelog.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => changelog.to_param}, valid_session
  #     }.to change(Changelog, :count).by(-1)
  #   end
  #
  #   it "redirects to the changelogs list" do
  #     changelog = Changelog.create! valid_attributes
  #     delete :destroy, {:id => changelog.to_param}, valid_session
  #     expect(response).to redirect_to(changelogs_url)
  #   end
  # end

end
