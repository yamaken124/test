require 'rails_helper'

RSpec.describe Users::Oauth::AuthorizationsController, type: :controller do

  describe 'POST #create' do
    let!(:oauth_application) { create(:oauth_application, consumer_key: 'cons') }
    let(:user) { create(:user) }
    context 'signed in' do
      before { user_sign_in user }
      it { post :create; expect(response).to redirect_to root_path }
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
        it { post :create, params; expect(response).to redirect_to edit_profile_path(continue: :credit_cards) }
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

      it { post :create, params; expect(response).to redirect_to root_path }
      it { expect{ post :create, params }.to change(User, :count).by(0) }
      it { expect{ post :create, params }.to change(OauthAccessToken, :count).by(0) }
    end
  end

  describe 'POST #sign_in_with_email_password' do

    let(:user) { create(:user) }
    let(:action) { :sign_in_with_email_password }
    let(:params) { { user: { email: 'shinozuka@finc.co.jp', password: 'password' } }}
    context 'signed in' do
      before { user_sign_in user }
      it { post action; expect(response).to redirect_to root_path }
    end

    describe 'User not found' do
      before do
        stub_request(:post, "#{Settings.internal_api.finc_app.host}/v1/users/login").to_return(status: 201, body: { access_token: nil }.to_json)
        post action, params
      end

      it { expect(response).to render_template :sign_in_with_email_password }

      it 'assigns new user' do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of User
      end
    end

    describe 'User found' do
      let(:oauth_application) { OauthApplication.find_by(consumer_key: Settings.oauth_applications.finc_app.consumer_key) }
      let!(:oauth_access_token) { create(:oauth_access_token, oauth_application_id: oauth_application.id, user_id: user.id, token: 'access') }
      it do
        stub_request(:post, "#{Settings.internal_api.finc_app.host}/v1/users/login").to_return(status: 201, body: { access_token: 'access' }.to_json)
        post action, params
        expect(response).to redirect_to root_path
      end
    end
  end
end
