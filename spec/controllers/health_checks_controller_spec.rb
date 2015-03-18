require 'rails_helper'

RSpec.describe HealthChecksController, type: :controller do
  describe 'GET #index' do
    before { get :show }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to eq 'ok' }
  end
end
