# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  kind       :integer          default(0)
#  name       :string
#  image_url  :string
#  link       :string
#  uri        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  # describe 'GET /index' do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
end
