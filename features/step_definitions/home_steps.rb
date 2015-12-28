def get_canvas_color_at(x,y)
  script = %{
    var canvas = $('#creativeCanvas')[0];
    var ctx = canvas.getContext('2d');
    var data = ctx.getImageData(#{x}, #{y}, 1, 1).data;
    return data;
  }
  colors = page.execute_script(script)
  {red: colors[0], green: colors[1], blue: colors[2]}
end

def number_of_cards
  script = "var cards = angular.element(document.body).scope().cards; return cards.length;"
  page.execute_script(script)
end

def number_of_dealt_cards
  script = "var result = angular.element(document.body).scope().dealtCards(); return result;"
  page.execute_script(script)
end


def cards_all_visible
  script = %{
    var cards = angular.element(document.body).scope().cards;
    var index;
    var result = true;
    for (index = 0; index < cards.length; ++index) {
        result = result && cards[index].visible;};
    return result;
  }
  page.execute_script(script)
end

def cards_all_facedown
  script = %{
    var cards = angular.element(document.body).scope().cards;
    var index;
    var result = true;
    for (index = 0; index < cards.length; ++index) {
        result = result && !cards[index].faceup;};
    return result;
  }
  page.execute_script(script)
end

def cards_all_at_origin
  script = %{
    var cards = angular.element(document.body).scope().cards;
    var index;
    var result = true;
    for (index = 0; index < cards.length; ++index) {
      result = result && cards[index].x == 0 && cards[index].y == 0 ;};
    return result;
  }
  page.execute_script(script)
end


def cards_at_position(x,y)
  script = %{
    var cards = angular.element(document.body).scope().cards;
    var index;
    var result = 0;
    for (index = 0; index < cards.length; ++index) {
       if (cards[index].x == #{x} && cards[index].y == #{y}) { result += 1} ;};
    return result;
  }
  page.execute_script(script)
end

Given(/^A user arrives at the root website$/) do
  load "#{Rails.root}/db/seeds.rb"
  visit root_path
  deal_button_enabled # wait for the page to load
end

def deal_button_enabled
  page.should have_button('Deal Card', disabled: false)
end

Then(/^They should see a deal cards button$/) do
  deal_button_enabled
end

And(/^They should see a game area$/) do
  page.should have_css('#creativeCanvas')
  expect(page.evaluate_script("$('#creativeCanvas')[0].height")).to eq 300
  expect(page.evaluate_script("$('#creativeCanvas')[0].width")).to eq 400
end

And(/^They should see a deck of cards$/) do
  expect(number_of_cards).to be 2
  expect(cards_all_visible).to be true
  expect(cards_all_facedown).to be true
  expect(cards_all_at_origin).to be true
end


And(/^There should not be a card in the dealt position$/) do
  expect(cards_at_position(180,100)).to eq 0
end

When(/^The user clicks the deal card button$/) do
  click_button('Deal Card')
  deal_button_enabled # wait for the deal to complete
end


Then(/^The number of dealt cards should be "([^"]*)"$/) do |arg|
  expect(number_of_dealt_cards).to be arg.to_i
end

And(/^There should  be a card in the dealt position$/) do
  expect(cards_at_position(180,100)).to eq 1
end