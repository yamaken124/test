# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  used_point_total       :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'wellness_mileage' do

    context 'lmi user or abc user' do
      it 'returns diff in total_points at finc_app_me and used_point_total' do
        user = create(:user, used_point_total: 5)
        allow_any_instance_of(User).to receive(:me_in_finc_app).and_return({ 'id' => User.lmi_user_ids.first, 'total_points' => 10, 'start_date' => '2015-02-23' })
        expect(user.wellness_mileage).to eq 5
      end
    end

    context 'Not a lmi user' do
      let(:user) { create(:user, used_point_total: 5) }
      context 'start before 2015-02-10' do
        it 'returns diff in total_points at finc_app_me and used_point_total' do
          allow_any_instance_of(User).to receive(:me_in_finc_app).and_return({ 'id' => 1, 'total_points' => 10, 'start_date' => '2015-01-11' })
          expect(user.wellness_mileage).to eq 5
        end
      end

      context 'start between 2015-02-11 and 2015-04-12' do
        context 'and not graduate' do
          it do
            allow_any_instance_of(User).to receive(:me_in_finc_app).and_return({ 'id' => 1, 'total_points' => 10, 'start_date' => '2015-03-11', 'graduates_on' => nil })
            expect(user.wellness_mileage).to eq 0
          end
        end

        context 'and graduated' do
          it 'returns diff in after_graduate_points and used_point_total' do
            allow_any_instance_of(User).to receive(:me_in_finc_app).and_return({ 'id' => 1, 'total_points' => 10, 'start_date' => '2015-03-11', 'graduates_on' => '2015-05-10', 'after_graduate_points' => 10 })
            expect(user.wellness_mileage).to eq 5
          end
        end
      end
    end

    it 'returns 0 if me_at_finc_app is not found' do
      user = create(:user, used_point_total: 5)
      expect(user.wellness_mileage).to eq 0
    end
  end
end
