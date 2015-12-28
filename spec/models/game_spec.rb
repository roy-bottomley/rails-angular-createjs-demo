# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  card_background :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Game do
  %w(id card_background).each do |column|
    it ("should respond to #{column}") {
      expect(Game.new).to respond_to(column.to_sym ) }
  end

  it ("should have the correct image list") {
    expect(Game::IMAGE_LIST).to eq ['card_background']

  }

  it ("should have many Games ") {
    expect(Game.reflect_on_association(:cards).macro).to  eq(:has_many)
  }
end
