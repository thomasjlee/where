# Array Extension

## Setup

This project was built with Ruby 2.6.1 with RSpec 3.8.0.

Download the repo and run `bundle install`.

! TODO

## Specs

To run the specs, run `bundle exec rspec`.

## Assumptions

A proper SQL abstraction should include sanitization, for which ActiveRecord::Sanitization could be used.

For the purposes of this exercise I've omitted this feature.

## Original Instructions

### Array Extension

Please write a module that gives `where` behavior to an array of hashes. (See
`test.rb` and make it pass, or feel free to convert the tests to your favorite
test framework.)
