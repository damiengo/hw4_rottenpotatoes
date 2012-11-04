require 'spec_helper'

describe Movie do

  FactoryGirl.define do
    factory :movie do
      title 'A Fake Title' # default values
      rating 'PG'
      release_date { 10.years.ago }
      director ''
    end
  end

  it 'find movies with the same director' do
    et = FactoryGirl.create(:movie, :title => 'E.T.', :director => 'Spielberg', :rating => 'G', :release_date => '21-Jun-2000')
    munich = FactoryGirl.create(:movie, :title => 'Munich', :director => 'Spielberg', :rating => 'G', :release_date => '21-Jun-2000')
    jones = FactoryGirl.create(:movie, :title => 'Indiana Jones', :director => 'Spielberg', :rating => 'G', :release_date => '21-Jun-2000')
    fake = [et, munich, jones]
    jones.find_similar_movies.should == fake    
  end

  it 'find alla ratings' do
    ratings = Movie.all_ratings
    ratings.should == %w(G PG PG-13 NC-17 R)
  end

end