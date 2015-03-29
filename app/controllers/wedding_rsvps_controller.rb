class WeddingRsvpsController < ApplicationController
  def index

  end

  def new
    @title = (params['change'])? 'Change RSVP' : 'New RSVP'

  end

  def create

    puts "create called"

    # see if email exists find
    existing_rsvp = Rsvp.where(:email => params[:email])
    if existing_rsvp.count > 0
      puts 'Existing RSVP'

      else

    end

  end

  def edit

  end

  def update
  end

  def show
  end


end
