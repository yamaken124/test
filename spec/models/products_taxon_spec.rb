# == Schema Information
#
# Table name: products_taxons
#
#  id         :integer          not null, primary key
#  product_id :integer
#  taxon_id   :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProductsTaxon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
