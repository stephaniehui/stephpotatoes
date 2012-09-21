class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]

    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if params[:sort] != session[:sort]
      session[:sort] = sort
      redirect_to :sort => sort, :ratings => @selected_ratings and return 
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return 
    end



    if @selected_ratings == {} 
      @movies = Movie.all
      case sort
      when 'title'
        @title_header = 'hilite'
        @movies = Movie.all(:order => :title)
        #ordering,@title_header = {:order => :title}, 'hilite'
      when 'release_date'
        @release_date_header = 'hilite'
        @movies = Movie.all(:order => :release_date)
        #ordering,@release_date_header = {:order => :release_date}, 'hilite'
      end
    else 
      @movies = Movie.where(:rating => (@selected_ratings.keys))
      case sort
      when 'title'
        @title_header = 'hilite'
        @movies = @movies.all(:order => :title)
        #ordering,@title_header = {:order => :title}, 'hilite'
      when 'release_date'
        @release_date_header = 'hilite'
        @movies = @movies.all(:order => :release_date)
        #ordering,@release_date_header = {:order => :release_date}, 'hilite'
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
