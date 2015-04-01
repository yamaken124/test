require 'rails_helper'

RSpec.describe Users::ProfilesController, type: :controller do

  before do
    @user = create(:user)
    user_sign_in @user
  end

  describe 'GET #edit' do

    it "assign user" do
      get :edit 
      expect(assigns(:user)).to eq @user
    end
    
    it "assign profile" do
      get :edit
      expect(assigns(:profile)).to be_new_record
    end
  end

  describe 'POST #create' do
    let(:params){
      { 
        profile: {
          last_name: "last",
          first_name: "first",
          last_name_kana: "last",
          first_name_kana: "first",
          phone: "phone" }
      }
    }
    it "create profile" do
      expect {
          post :create, params
      }.to change(Profile, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    before do
      @profile = create(:profile, user_id: @user.id)
    end
    let(:params){
      {
        profile: {
          last_name: "last",
          first_name: "first",
          last_name_kana: "last",
          first_name_kana: "first",
          phone: "phone" }
      }
    }
    it "update profile" do
      expect {
          put :update, params
      }.to change(Profile, :count).by(0)
    end
  end 
end
