require 'net/http'

class MoviesController < ApplicationController
  MOVIES_PER_PAGE = 10

  def index
    get_movies
  end

  def show
    get_movie
    get_people
    get_movies
  end

  private

  def get_movies
    @url = 'https://ghibliapi.vercel.app/films/'
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    @movies = JSON.parse(response)
    @random = @movies.sample
    # paginate
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

  # def paginate
  #   total_items = @movies.size # Total number of items you want to paginate
  #   current_page = params[:page].to_i || 1 # Retrieve the current page from params or set a default

  #   total_pages = (total_items.to_f / MOVIES_PER_PAGE).ceil
  #   offset = (current_page - 1) * MOVIES_PER_PAGE
  #   limit = MOVIES_PER_PAGE

  #   @movies = retrieve_movies(@movies, offset, limit) # Implement your own method to fetch the items
  #   render 'index', locals: {
  #     items: @movies,
  #     total_items: @movies.size,
  #     items_per_page: MOVIES_PER_PAGE,
  #     current_page: current_page,
  #     total_pages: total_pages
  #   }
  # end

  # def retrieve_movies(movies, offset, limit)
  #   movies[offset, limit]
  # end
end
