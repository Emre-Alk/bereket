# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  data              :json
#  processing_errors :text
#  source            :string
#  status            :enum             default("pending"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
