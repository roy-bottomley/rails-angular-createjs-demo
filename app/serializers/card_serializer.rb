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

class CardSerializer < ActiveModel::Serializer
  attributes :id, :image_manifest, :image_order

  def image_order
    Card::IMAGE_ORDER
  end

  def image_manifest
    Card::IMAGE_ORDER.collect{|k| {src: ActionController::Base.helpers.image_url(object.send(k)), id: k}}
  end

end
