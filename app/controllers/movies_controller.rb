require 'net/http'

class MoviesController < ApplicationController
  def index
    @url = 'https://ghibliapi.vercel.app/films/'
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    @movies = JSON.parse(response)
  end

  def show
    movie_id = params[:id]
    @movie = "https://ghibliapi.vercel.app/films/#{movie_id}"
    uri = URI(@movie)
    response = Net::HTTP.get(uri)
    @movie_details = JSON.parse(response)

    people_uri = URI('https://ghibliapi.vercel.app/people/')
    people_response = Net::HTTP.get(people_uri)
    @people = JSON.parse(people_response)
  end
end
