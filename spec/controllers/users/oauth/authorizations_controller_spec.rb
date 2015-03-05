require 'rails_helper'

RSpec.describe Users::Oauth::AuthorizationsController, type: :controller do

  describe 'POST #create' do
    let!(:oauth_application) { create(:oauth_application, consumer_key: 'cons') }
    let(:user) { create(:user) }
    context 'signed in' do
      before { user_sign_in user }
      it { post :create; expect(response).to redirect_to products_path }
    end

    context 'invalid consumer_key' do
      it { expect { post :create, consumer_key: 'invalid', access_token: 'access' }.to raise_error(ActionController::BadRequest) }
    end

    context 'invalid access_token' do
      before { stub_request(:get, "#{Settings.internal_api.finc_app.host}/v2/me").to_return(status: 400, body: { error: 'invalid_access_token'}.to_json) }
      it { expect { post :create, consumer_key: 'cons', access_token: 'invalid' }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'not signed up yet' do
      before { stub_request(:get, "#{Settings.internal_api.finc_app.host}/v2/me").to_return(body: { user: { last_name: 'shino', email: 'mockuser@finc.co.jp' } }.to_json) }
      context 'valid consumer_key' do
        let(:params) { { consumer_key: 'cons', access_token: 'access' } }
        it { post :create, params; expect(response).to redirect_to profile_path }
        it { expect{ post :create, params }.to change(User, :count).by(1) }
        it { expect{ post :create, params }.to change(OauthAccessToken, :count).by(1) }
      end
    end

    context 'already signed up' do
      before do
        stub_request(
          :get,
          "#{Settings.internal_api.finc_app.host}/v2/me")
          .to_return(body: { user: { last_name: 'shino', email: 'mockuser@finc.co.jp' } }.to_json)
      end

      let!(:oauth_access_token) { create(:oauth_access_token, oauth_application_id: oauth_application.id, user_id: user.id, token: 'access') }
      let(:params) { { consumer_key: 'cons', access_token: 'access' } }

      it { post :create, params; expect(response).to redirect_to products_path }
      it { expect{ post :create, params }.to change(User, :count).by(0) }
      it { expect{ post :create, params }.to change(OauthAccessToken, :count).by(0) }
    end
  end
end
