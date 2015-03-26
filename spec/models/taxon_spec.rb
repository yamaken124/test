# == Schema Information
#
# Table name: taxons
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  position    :integer
#  name        :string(255)
#  permalink   :string(255)
#  description :text(65535)
#  lft         :integer          not null
#  rgt         :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Taxon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
