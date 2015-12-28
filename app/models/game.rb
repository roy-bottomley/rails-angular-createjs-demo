# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  card_background :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ActiveRecord::Base
  IMAGE_LIST = ['card_background']

  has_many :cards, inverse_of: :game, dependent: :destroy
end
