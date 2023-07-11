require 'net/http'

class MoviesController < ApplicationController
  def index
    get_movies
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
    @url = 'https://ghibliapi.vercel.app/films/'
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    @movies = JSON.parse(response)
    @random = @movies.sample
  end

  def get_movie
    movie_id = params[:id]
    @movie = "https://ghibliapi.vercel.app/films/#{movie_id}"
    uri = URI(@movie)
    response = Net::HTTP.get(uri)
    @movie_details = JSON.parse(response)
  end

  def get_people
    people_uri = URI('https://ghibliapi.vercel.app/people/')
    people_response = Net::HTTP.get(people_uri)
    @people = JSON.parse(people_response)
  end

  def get_count
    @people_count = []
    @people.each do |person|
      if person['films'].include?(@movie)
        @people_count << person
      end
    end
  end

  def paginate
    page_size = 10
    one_page = get_page_of_data params[:page], page_size
    @paginatable_array = Kaminari.paginate_array(one_page.data, total_count: one_page.total_count).page(params[:page]).per(page_size)
  end
end
