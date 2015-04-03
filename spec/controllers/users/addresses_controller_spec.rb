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

    it "assign address" do
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
          zipcode: "1500000",
          address: "xxxx",
          city: "xxxx",
          phone: "09012341234"
        },
        continue: checkout_state_path(state: :payment)
      }
    }
    it "create new record" do
      expect {
      post :create, params
      }.to change(Address, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let(:address) { create(:address, user_id: @user.id) }
    let(:params) do
      {
        id: address.id,
        address: attributes_for(:address, address: "updated_address")
      }
    end

    before { patch :update, params }
    it "assign address" do
      expect(assigns(:address)).to eq address
    end
    it "updates" do
      expect{ patch :update, params; address.reload }.to change(address, :address).to('updated_address')
    end
    it 'account_addresses_path' do
      expect(response).to redirect_to account_addresses_path
    end
  end

  describe 'DELETE #destroy' do
    let(:address) { create(:address, user_id: @user.id) }
    let(:params) do
      {
        id: address.id,
        address: attributes_for(:address, is_active: false)
      }
    end
    before { patch :destroy, params }

    it 'updates' do
      address.reload
      expect(address.deleted_at).not_to eq nil
    end
    it 'redirects to account_addresses_path' do
      expect(response).to redirect_to account_addresses_path
    end

  end

end
