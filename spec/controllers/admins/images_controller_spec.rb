require 'rails_helper'

RSpec.describe Admins::ImagesController, type: :controller do

  before do
    @admin = create(:admin)
    admin_sign_in @admin
    @product = create(:product)
    @variant = create(:variant, product_id: @product.id )
    @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), id: 1, imageable_id: @variant.id, imageable_type: "Variant" )
 
  end 

  describe 'GET #index' do  
    before { get :index, :imageable_type => "Variant", variant_id: @variant.id }

    it { expect(response).to render_template :index }
    it { expect(assigns(:images)).to eq [ @image ]}
  end 

  describe 'GET #new' do
    before{ get :new, :imageable_type => "Variant", variant_id: @variant.id }
    it { expect(response).to render_template :new }
    it { expect(assigns(:image)).to be_new_record }
  end 

  describe 'POST #create' do
    it "saves new image in the database" do
      expect{ post :create, :imageable_type => "Variant", variant_id: @variant.id, image: attributes_for(:image) }.to change(Image, :count).by(1) 
    end
  end   

  describe 'GET #edit' do
    before{ get :edit, :imageable_type => "Variant", variant_id: @variant.id, id: @image.id }
    it { expect(assigns(:image)).to eq @image  }
    it { expect(response).to render_template :edit }
  end   

  describe 'PATCH #update' do
    before{ patch :update, :imageable_type => "Variant", variant_id: @variant.id, image: attributes_for(:image), id: @image.id }
    it { expect(assigns(:image)).to eq @image }
  end    

  describe 'DELETE #destroy' do
    before{@image_2 = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), id: 2, imageable_id: @variant.id, imageable_type: "Variant" )}
    it "deletes" do
      expect{ delete :destroy, :imageable_type => "Variant", variant_id: @variant.id, id: @image.id}.to change(Image, :count).by(-1)
    end 
  end   
end
