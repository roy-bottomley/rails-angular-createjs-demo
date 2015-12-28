# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  card_background :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class GameSerializer < ActiveModel::Serializer
  attributes :id, :image_manifest, :image_list

  def image_list
    Game::IMAGE_LIST
  end

  def image_manifest
    Game::IMAGE_LIST.collect{|k| {src: ActionController::Base.helpers.image_url(object.send(k)), id: k}}
  end

end
