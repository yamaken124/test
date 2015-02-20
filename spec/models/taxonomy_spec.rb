# == Schema Information
#
# Table name: taxonomies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Taxonomy, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
