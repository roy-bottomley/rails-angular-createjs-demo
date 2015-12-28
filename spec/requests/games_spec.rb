require 'spec_helper'

describe "Game Requests" do
  before(:all) {
    load "#{Rails.root}/db/seeds.rb"

    RSpec::Matchers.define :contain_data_for_game do |expected|
      msg = ''
      match do |actual|
        body = JSON.parse(actual)
        if body['id'] != expected.id
          msg = "expected that #{actual} would contain key :id with value #{expected.id} but it was #{body['id']}"
        elsif  body['image_list'] != Game::IMAGE_LIST
          msg = "expected that #{actual} would contain key :image_list with value #{ Game::IMAGE_LIST} but it was #{body['image_list']}"
        elsif  !body['image_manifest'].kind_of?(Array)
          msg = "expected that #{actual} would contain key :image_manifest with an array as its value but it was #{body['image_manifest']}"
        elsif  body['image_manifest'].length !=  Game::IMAGE_LIST.length
          msg = "expected that #{actual} would contain key :image_manifest with an array of size #{Game::IMAGE_LIST.length}  but it's size was #{body['image_manifest'].length}"
        else
          Game::IMAGE_LIST.each do |k|
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
  }
  describe "GET SHOW, api_game_path, api/game/:id" do
    it "should return status 200" do
      get api_game_path(Game.first)
      expect(response.status).to eq 200
    end

    it "should return a type of json" do
      get api_game_path(Game.first)
      expect(response.content_type).to eq("application/json")
    end

    it "should return the requested game" do
      game = Game.last
      get api_game_path(game)
      expect(response.body).to contain_data_for_game(game)
    end

    it "should return a default game if aninvalid request made" do
      game = Game.last
      get api_game_path(game.id + 1)
      expect(response.body).to contain_data_for_game(Game.first)
    end

  end

  describe "GET INDEX, games_path, /games" do
    it "should return status 200" do
      get games_path
      expect(response.status).to eq 200
    end

    it "should render the correct template" do
      get games_path
      expect(response).to render_template(:index)
      expect(response.body).to include("Demo of Rails/Angular/CreateJs tested with /Jasmine/Rspec/Cucumber")
    end

  end
end
