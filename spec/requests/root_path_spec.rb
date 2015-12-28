require 'spec_helper'

describe "Root Request" do

    it "should the home page" do
      get root_path
      expect(response.body).to include("Demo of Rails/Angular/CreateJs tested with /Jasmine/Rspec/Cucumber")
    end
end
