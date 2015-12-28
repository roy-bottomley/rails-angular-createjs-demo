require 'spec_helper'

describe "Card Requests" do
  before(:all) {
    load "#{Rails.root}/db/seeds.rb"

    RSpec::Matchers.define :contain_data_for_card do |expected|
      msg = ''
      match do |actual|
        body = JSON.parse(actual)
        if body['id'] != expected.id
          msg = "expected that #{actual} would contain key :id with value #{expected.id} but it was #{body['id']}"
        elsif  body['image_order'] != Card::IMAGE_ORDER
          msg = "expected that #{actual} would contain key :image_order with value #{ Card::IMAGE_ORDER} but it was #{body['image_order']}"
        elsif  !body['image_manifest'].kind_of?(Array)
          msg = "expected that #{actual} would contain key :image_manifest with an array as its value but it was #{body['image_manifest']}"
        elsif  body['image_manifest'].length !=  Card::IMAGE_ORDER.length
          msg = "expected that #{actual} would contain key :image_manifest with an array of size #{Card::IMAGE_ORDER.length}  but it's size was #{body['image_manifest'].length}"
        else
          Card::IMAGE_ORDER.each do |k|
            manifest = body['image_manifest'].select{|m| m['id'] == k}
            if manifest.blank?
              msg = "expected that #{body['image_manifest']} would contain a hash with a key of :id whose value was #{k} but it did not"
              break
            elsif manifest.length > 1
              msg = "expected that #{body['image_manifest']} would contain a hash with a key of :id whose value was #{k} but it contained two such keys"
              break
            elsif  manifest[0]['src'] !=  ActionController::Base.helpers.image_url(expected.send(k))
              msg = "expected that the :src key in element #{manifest} in the array :image_manifest of the response would contain #{ActionController::Base.helpers.image_url(expected.send(k))} was #{manifest[0]['src']}"
              break
            end
          end
        end
        msg.blank?
      end
      failure_message_for_should do |actual|
        msg
      end
    end

    RSpec::Matchers.define :contain_cards_for_the_game do |expected|
      msg = ''
      match do |actual|
        body = JSON.parse(actual)
        if body.length != expected.cards.length
          msg = "expected that #{actual} would contain #{expected.cards.length} cards but it contained #{body.length}"
        else
          body.each do |c|
            game_card = expected.cards.select{|card| card.id = c['id']}
            if game_card.blank?
              "expected that #{actual} would contain only cards in game #{expected.id} but it contained #{c} which is not in this game"
              break
            end
          end
        end
        msg.blank?
      end
      failure_message_for_should do |actual|
        msg
      end
    end

  }

  describe "GET SHOW, api_card_path, api/card/:id" do
    before(:all) {
      @card = Card.first
      get api_card_path(@card)
    }
    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should return the correct card" do
      expect(response.body).to contain_data_for_card( @card)
    end

  end

  describe "GET INDEX, api_cards_path, api/cards" do
    before(:all) {
      load "#{Rails.root}/db/seeds.rb"
      get api_cards_path
    }
    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should return all the cards" do
      body = JSON.parse(response.body)
      expect(body.length).to be(Card.all.length)
    end
  end

  describe "GET cards for a game, api_game_cards_path, api/games/:id/cards" do
    before(:all) {
      load "#{Rails.root}/db/seeds.rb"
      @game = Game.first
      get api_game_cards_path(@game)
    }
    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should return all the cards for a game" do
      expect(response.body).to contain_cards_for_the_game(@game)
    end

  end

end
