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

  context 'when passed a string' do
    it 'finds an exact match' do
      expect(@fixtures.where("name = 'The Wolf'")).to eq [@wolf]
    end

    it 'finds a match with multiple criteria' do
      condition = "name = 'The Wolf' and title = 'Pulp Fiction'"
      expect(@fixtures.where(condition)).to eq [@wolf]
    end

    it 'allows interpolation' do
      name = 'Boris The Blade'
      expect(@fixtures.where("name = #{name}")).to eq [@boris]
    end

    it 'casts string to number if "column" type is a number' do
      condition = "name = 'Charles De Mar' and rank = '3'"
      expect(@fixtures.where(condition)).to eq [@charles]
    end

    it 'can be chained' do
      condition_a = "name = 'Charles De Mar'"
      condition_b = "rank = '3'"
      expect(@fixtures.where(condition_a).where(condition_b)).to eq [@charles]
    end
  end

  context 'when passed an array' do
    context 'using ordered placeholders' do
      it 'finds an exact match' do
        expect(@fixtures.where(['title = ?', 'Snatch'])).to eq [@boris]
      end

      it 'finds a match with multiple criteria' do
        conditions = ['name = ? and rank = ?', 'Glengarry Glen Ross', 5]
        expect(@fixtures.where(conditions)).to eq [@glen]
      end
    end

    context 'using named placeholders' do
      it 'finds an exact match' do
        condition = ['title = :title', { title: 'Snatch' }]
        expect(@fixtures.where(condition)).to eq [@boris]
      end

      it 'finds a match with multiple criteria' do
        conditions = [
          'name = :name and rank = :rank',
          { name: 'Glengarry Glen Ross', rank: 5 }
        ]
        expect(@fixtures.where(conditions)).to eq [@glen]
      end
    end
  end

  context 'when passed a hash' do
    it 'finds an exact match' do
      expect(@fixtures.where(name: 'The Wolf')).to eq [@wolf]
    end

    it 'finds a partial match' do
      expect(@fixtures.where(title: /^B.*/)).to eq [@charles, @glen]
    end

    it 'finds multiple exact matches' do
      expect(@fixtures.where(rank: 4)).to eq [@boris, @wolf]
    end

    it 'finds a match with multiple criteria' do
      expect(@fixtures.where(rank: 4, quote: /get/)).to eq [@wolf]
    end

    it 'can be chained' do
      expect(@fixtures.where(quote: /if/i).where(rank: 3)).to eq [@charles]
    end

    it 'returns an empty array when there is no match' do
      expect(@fixtures.where(rank: 10)).to eq []
    end
  end
end
