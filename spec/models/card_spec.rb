# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  background :string
#  face       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  eye        :string
#  eyebrow    :string
#  hair       :string
#  nose       :string
#  mouth      :string
#  game_id    :integer
#

require 'spec_helper'

describe Card do

  %w(id background face eye eyebrow hair nose mouth game_id game).each do |column|
    it ("should respond to #{column}") {
      expect(Card.new).to respond_to(column.to_sym ) }
  end

  it ("should have the correct image order") {
    expect(Card::IMAGE_ORDER).to eq  [ 'background',
                                        'face',
                                        'eye' ,
                                        'eyebrow',
                                        'hair',
                                        'nose',
                                        'mouth'
                                        ]
  }

  it ("should belong to a game ") {
    expect(Card.reflect_on_association(:game).macro).to  eq(:belongs_to)
  }

end
