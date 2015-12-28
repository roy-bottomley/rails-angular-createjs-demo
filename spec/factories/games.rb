# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  card_background :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    card_background "MyString"
  end
end
