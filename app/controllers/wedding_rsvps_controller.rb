class WeddingRsvpsController < ApplicationController
  def index

  end

  def new
    @title = (params['change'])? 'Change RSVP' : 'New RSVP'

  end

  def create

    puts "create called"



  end

  def edit

  end

  def update
  end

  def show
  end


end
