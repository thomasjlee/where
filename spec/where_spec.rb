require 'spec_helper'
require_relative '../where'

class Array
  include Where
end

RSpec.describe Where do
  before do
    @boris = {
      name:  'Boris The Blade',
      quote: 'Heavy is good. Heavy is reliable. '\
             "If it doesn't work you can always hit them.",
      title: 'Snatch',
      rank:  4
    }

    @charles = {
      name:  'Charles De Mar',
      quote: 'Go that way, really fast. If something gets in your way, turn.',
      title: 'Better Off Dead',
      rank:  3
    }

    @wolf = {
      name:  'The Wolf',
      quote: 'I think fast, I talk fast and I need you guys to act fast '\
             'if you wanna get out of this',
      title: 'Pulp Fiction',
      rank:  4
    }

    @glen = {
      name:  'Glengarry Glen Ross',
      quote: 'Put. That coffee. Down. Coffee is for closers only.',
      title: 'Blake',
      rank:  5
    }

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  it 'finds an exact match' do
    expect(@fixtures.where(name: 'The Wolf')).to eq [@wolf]
  end

  it 'finds a partial match' do
    expect(@fixtures.where(title: /^B.*/)).to eq [@charles, @glen]
  end

  it 'finds multiple exact matches' do
    expect(@fixtures.where(rank: 4)).to eq [@boris, @wolf]
  end

  it 'finds matches with multiple criteria' do
    expect(@fixtures.where(rank: 4, quote: /get/)).to eq [@wolf]
  end

  it 'can be chained' do
    expect(@fixtures.where(quote: /if/i).where(rank: 3)).to eq [@charles]
  end
end
