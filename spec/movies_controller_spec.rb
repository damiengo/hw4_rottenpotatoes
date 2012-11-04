require 'spec_helper'

describe MoviesController, :type => :controller do

  describe 'routing' do
    it "routes finding similar movies" do
      { :get => '/find_similar_movies/1' }.should route_to({:controller => "movies", :action => "find_similar_movies", :id => "1"})
    end
  end

  describe 'finding similar movies' do
    it 'should call the model method that performs similar movies search' do
      m = mock_model(Movie)
      m.stub(:find_similar_movies)
      Movie.should_receive(:find).and_return(m)
      m.should_receive(:find_similar_movies).and_return(Array.new)
      get :find_similar_movies, {:id => 1}
    end
    it 'should redirect to index if empty director' do
      m = mock_model(Movie, :title => 'La 7eme compagnie', :director => '')
      m.stub(:find_similar_movies)
      Movie.should_receive(:find).and_return(m)

      get :find_similar_movies, {:id => 1}
      response.should redirect_to '/movies'
      flash[:notice].should eql("'La 7eme compagnie' has no director info")
    end
  end

  describe 'show a movie' do
    it 'should call the model method that find a movie' do
      m = mock_model(Movie)
      Movie.should_receive(:find).and_return(m)
      get :show, {:id => 1}
    end
  end

  describe 'create a movie' do
    it 'redirect to the home with a flash message' do
      m = mock_model(Movie, :id => 1, :title => 'La 7eme compagnie', :director => '')
      Movie.should_receive(:create!).and_return(m)

      get :create
      response.should redirect_to '/movies'
      flash[:notice].should eql("La 7eme compagnie was successfully created.")
    end
  end

  describe 'edit a movie' do
    it 'should find the movie' do
      m = mock_model(Movie, :id => 1, :title => 'La 7eme compagnie', :director => '')
      Movie.should_receive(:find).and_return(m)

      get :edit, {:id => 1}
    end
  end

  describe 'update a movie' do
    it 'redirect to the movie page with a flash message' do
      m = mock_model(Movie, :id => 1, :title => 'La 7eme compagnie', :director => '')
      Movie.should_receive(:find).and_return(m)
      m.should_receive(:update_attributes!)

      get :update, :id => 1
      response.should redirect_to '/movies/1'
      flash[:notice].should eql("La 7eme compagnie was successfully updated.")
    end
  end

  describe 'destroy a movie' do
    it 'redirect to the home with a flash message' do
      m = mock_model(Movie, :id => 1, :title => 'La 7eme compagnie', :director => '')
      Movie.should_receive(:find).and_return(m)
      m.should_receive(:destroy)

      delete :destroy, :id => 1
      response.should redirect_to '/movies'
      flash[:notice].should eql("Movie 'La 7eme compagnie' deleted.")
    end
  end

  describe 'Index page' do
    it 'should display simple page with no params' do
      ratings = %w(G PG PG-13 NC-17 R)
      Movie.should_receive(:all_ratings).and_return(ratings)
      Movie.should_receive(:find_all_by_rating).with(ratings, nil)

      get :index
    end
    it 'should display simple page with order by title' do
      ratings = %w(G PG PG-13 NC-17 R)
      Movie.should_receive(:all_ratings).and_return(ratings)

      get :index, :sort => 'title'
    end
    it 'should display simple page with order by release date' do
      ratings = %w(G PG PG-13 NC-17 R)
      Movie.should_receive(:all_ratings).and_return(ratings)

      get :index, :sort => 'release_date'
    end
    it 'should display simple page with selected ratings' do
      ratings = %w(G PG PG-13 NC-17 R)
      Movie.should_receive(:all_ratings).and_return(ratings)

      get :index, :ratings => ['G', 'R']
    end
  end

end