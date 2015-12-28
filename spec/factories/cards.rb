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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    background ""
    face "MyString"
  end
end
