require 'net/http'

class MoviesController < ApplicationController
  def index
    get_movies
    search
    filter
    @paginated_movies = Kaminari.paginate_array(@movies).page(params[:page])
  end

  def show
    get_movie
    get_people
    get_movies
    get_count
  end

  private

  def get_movies
    @url = 'https://ghibli.rest/films'
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    @movies = JSON.parse(response)
    @random = @movies.sample
  end

  def get_movie
    movie_id = params[:id]
    @movie = "https://ghibli.rest/films?id=#{movie_id}"
    uri = URI(@movie)
    response = Net::HTTP.get(uri)
    @movie_details = JSON.parse(response)[0]
  end

  def get_people
    people_uri = URI('https://ghibli.rest/people/')
    people_response = Net::HTTP.get(people_uri)
    @people = JSON.parse(people_response)
  end

  def get_count
    @people_count = []
    @people.each do |person|
      if person['films'].include?(@movie)
        # @people_count << person if person['name'] != @movie_details['director'] || @movie_details['producer']
        @people_count << person
      end
    end
  end

  def paginate
    page_size = 10
    one_page = get_page_of_data params[:page], page_size
    @paginatable_array = Kaminari.paginate_array(one_page.data, total_count: one_page.total_count).page(params[:page]).per(page_size)
  end

  def search
    if params[:query]
      results = []
      @movies.each do |movie|
        results << movie if movie['title'].downcase.include?(params[:query].downcase)
        results << movie if movie['release_date'].include?(params[:query])
      end
      @movies = results
    end
  end

  def filter
    sorted_movies = @movies.sort_by { |movie| movie['release_date'] }
    case params[:filter]
    when 'Old'
      @movies = sorted_movies
    when 'New'
      @movies = sorted_movies.reverse
    end
  end
end
