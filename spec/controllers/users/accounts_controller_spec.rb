require 'rails_helper'

RSpec.describe Users::AccountsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }
  describe 'GET #show' do
    before { get :show }
    it { expect(response).to render_template :show }
    it { expect(assigns(:me)).to eq user }
    it { expect(assigns(:wellness_mileage)).to eq user.wellness_mileage }
  end
end
