require 'rails_helper'

RSpec.describe Users::AddressesController, type: :controller do
  before do
    @user = create(:user)
    user_sign_in @user
    @address1 = create(:address, user_id: @user.id)
  end

  describe 'GET #index' do
    it "assign user" do
      get :index
      expect(assigns(:user)).to eq @user
    end
    
    it "assign profile" do
      get :index
      expect(assigns(:addresses)).to eq [@address1]
    end
  end

  describe 'GET #new' do
    it "assign user" do
      get :new
      expect(assigns(:user)).to eq @user
    end
    
    it "assign address" do
      get :new
      expect(assigns(:address)).to be_new_record
    end
  end

  describe 'GET #edit' do
    let(:params){ {id: @address1.id} }
    it "assign user" do
      get :edit, params
      expect(assigns(:user)).to eq @user
    end
    
    it "assign address" do
      get :edit, params
      expect(assigns(:address)).to eq @address1
    end
  end

  describe 'POST #create' do
    let(:params){
      { 
        address: {
          last_name: "xxxx", 
          first_name: "xxxx", 
          zipcode: "xxxx", 
          address: "xxxx", 
          city: "xxxx", 
          phone: "xxxx"
        }
      }
    }
    it "create new record" do
      expect {
      post :create, params
      }.to change(Address, :count).by(1)
    end
  end
end
