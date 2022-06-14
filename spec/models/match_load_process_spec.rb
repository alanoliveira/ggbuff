# frozen_string_literal: true

# == Schema Information
#
# Table name: match_load_processes
#
#  id         :integer          not null, primary key
#  state      :integer          default("created")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :integer          not null
#
# Indexes
#
#  index_match_load_processes_on_player_id  (player_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#
require "rails_helper"

RSpec.describe MatchLoadProcess, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
