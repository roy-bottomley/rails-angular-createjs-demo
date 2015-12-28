# TF_Cards
This is a snapshot of a current project. I thought I'd save this as it is a good starting point for a project using Rails/AngularJS and the [CreateJS](http://www.createjs.com/) graphics library and jasmine/rspec/cucumber testing. It contains a directive to instantiate CreateJS and all the logic for controlling objects on the canvas is in Angular factories/controllers. The object definitions are in a database and are accessed though AngularJS which interfaces to Rails through a REST api.

## Testing
The project includes a full test suite which shows how to test angular factories/directives and services using Jasmine. It has examples of mocking factories and services as well as custom jasmine matchers. It also shows how to handle angular promises when testing.

The Rails code is tested using Rspec and Cucumber is used for integration testing.

Run all the Rspec tests with `bundle exec rspec spec`

Run all Jasmine tests with `bundle exec rake spec:javascript` or run a rails server and navigate to /specs

Run all the Cucumber tests with `bundle exec rake cucumber:all`

Note: Jasmine test may have a message along the lines
`Unsafe JavaScript attempt to access frame with URL about:blank ... `
after the tests run, this is a
[known issue](https://github.com/n1k0/casperjs/issues/1068)
and does not affect the tests.

## Features
* **CreateJS Directive:**  Ensure that CreateJS is [downloaded](http://www.createjs.com/downloads) and in your app/assets/javascripts directory and is included in your application.js file. Then just include the directive on a page to create a CreateJS stage accessible from angular.
* **Rest API:**  The factory in serverInterface.js.coffee provides complete interface to Rails and includes methods for creating Angular factories from the the json served by rails.
* **Angular Testing:** Complete testing of Angular factories/services and directives included which includes examples of many if not all Jasmine/Angular test requirements.
* **Integration Testing:** Testing of complete system from database to canvas display through rails/angular and CreateJS using Cucumber.


## Installing
Just clone the repo and run a rails server in development mode (production database not included).

## Dependencies

This was written using

* ruby 2.2.3
* rails 4.2.5
* angular 1.4.7
* CreateJS easeljs-0.8.1
* CreateJS preloadjs-0.6.1
* CreateJS tweenjs-0.6.1

and tested using

* Jasmine 2.3.4
* Rspec 3.3.2
* Cucumber 1.3.20

a full list of dependencies is:

  * actionmailer (4.2.5)
  * actionpack (4.2.5)
  * actionview (4.2.5)
  * active_model_serializers (0.9.3)
  * activejob (4.2.5)
  * activemodel (4.2.5)
  * activerecord (4.2.5)
  * activesupport (4.2.5)
  * angularjs-rails (1.4.7)
  * annotate (2.6.10)
  * arel (6.0.3)
  * awesome_print (1.2.0)
  * binding_of_caller (0.7.2)
  * builder (3.2.2)
  * bundler (1.6.2)
  * byebug (8.2.0)
  * capybara (2.5.0)
  * childprocess (0.5.6)
  * coffee-rails (4.1.0)
  * coffee-script (2.4.1)
  * coffee-script-source (1.10.0)
  * cucumber (1.3.20)
  * cucumber-rails (1.4.2)
  * database_cleaner (1.2.0)
  * debug_inspector (0.0.2)
  * diff-lcs (1.2.5)
  * erubis (2.7.0)
  * execjs (2.6.0)
  * factory_girl (4.3.0)
  * factory_girl_rails (4.3.0)
  * ffi (1.9.10)
  * gherkin (2.12.2)
  * globalid (0.3.6)
  * i18n (0.7.0)
  * jasmine-core (2.3.4)
  * jasmine-rails (0.12.2)
  * jbuilder (2.3.2)
  * jquery-rails (4.0.5)
  * json (1.8.3)
  * loofah (2.0.3)
  * mail (2.6.3)
  * mime-types (2.6.2)
  * mini_portile (0.6.2)
  * minitest (5.8.2)
  * multi_json (1.11.2)
  * multi_test (0.1.2)
  * nokogiri (1.6.6.2)
  * phantomjs (1.9.8.0)
  * rack (1.6.4)
  * rack-test (0.6.3)
  * rails (4.2.5)
  * rails-deprecated_sanitizer (1.0.3)
  * rails-dom-testing (1.0.7)
  * rails-html-sanitizer (1.0.2)
  * railties (4.2.5)
  * rake (10.4.2)
  * rdoc (4.2.0)
  * rspec-core (2.14.7)
  * rspec-expectations (2.14.4)
  * rspec-mocks (2.14.4)
  * rspec-rails (2.14.1)
  * rubyzip (1.1.7)
  * sass (3.4.19)
  * sass-rails (5.0.4)
  * sdoc (0.4.1)
  * selenium-webdriver (2.46.2)
  * slim (3.0.6)
  * slim-rails (3.0.1)
  * spring (1.4.1)
  * sprockets (3.4.0)
  * sprockets-rails (2.3.3)
  * sqlite3 (1.3.11)
  * temple (0.7.6)
  * thor (0.19.1)
  * thread_safe (0.3.5)
  * tilt (2.0.1)
  * tzinfo (1.2.2)
  * uglifier (2.7.2)
  * web-console (2.2.1)
  * websocket (1.2.2)
  * xpath (2.0.0)

