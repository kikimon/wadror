class RatingsController < ApplicationController
  def index

     @top_beers = Rails.cache.fetch("beer top 3", expires_in:10.minutes) {Beer.top(3)}
     @top_breweries = Rails.cache.fetch("brewery top 3",  expires_in:10.minutes) {Brewery.top(3)}
     @top_users = Rails.cache.fetch("user top 3", expires_in:10.minutes) {User.top(3)}
     @top_styles = Rails.cache.fetch("style top", expires_in:10.minutes) {Style.top(3)}
     @ratings = Rails.cache.fetch("all ratings", expires_in:10.minutes) {Rating.all}
     @recent_ratings = Rails.cache.fetch("recent ratings", expires_in:10.minutes) {Rating.recent}
     #@top_breweries = Brewery.top 3
     #@top_beers = Beer.top 3
     #@top_users = User.top 3
     #@top_styles = Style.top 3
     #@recent_ratings = Rating.recent
     #@ratings = Rating.all
  end
  
  def new
     @rating = Rating.new
     @beers = Beer.all   	
  end
  
  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
 
end
