# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  kind       :integer          default("0")
#  name       :string
#  image_url  :string
#  link       :string
#  uri        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Tag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
