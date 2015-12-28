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

class Card < ActiveRecord::Base
  IMAGE_ORDER = [ 'background',
                  'face',
                  'eye' ,
                  'eyebrow',
                  'hair',
                  'nose',
                  'mouth'
                ]

  belongs_to :game, inverse_of: :cards
end
