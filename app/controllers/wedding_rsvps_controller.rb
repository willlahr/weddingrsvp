class WeddingRsvpsController < ApplicationController
  def index

  end

  def new
    @title = (params['change'])? 'Change RSVP' : 'New RSVP'

  end

  def create


    Rsvp.create_domain
    Person.create_domain

    # see if email exists find
    existing_rsvp = Rsvp.where(:email => params[:email])
    if existing_rsvp.count > 0
      puts 'Existing RSVP'
      rsvp = existing_rsvp.first
      redirect_to email_verify_wedding_rsvp_path(rsvp_id: rsvp.id  )


      else

      puts 'New RSVP needed'
      rsvp = Rsvp.new
      rsvp.email = params[:email]
      rsvp.validation_string = SecureRandom.hex(20)
      rsvp.save

      redirect_to edit_wedding_rsvp_path(rsvp_id: rsvp.id, validation_string: rsvp.validation_string  )
    end

  end

  def email_verify

  end

  def send_edit_link
    redirect_to edit_link_thanks_wedding_rsvp_path(rsvp_id: params[:rsvp_id])

  end

  def edit_link_thanks
    rsvp = Rsvp.find(params[:rsvp_id])
    @email = rsvp.email

  end


  def edit

     unless params[:rsvp_id] && params[:validation_string]
       redirect_to '/'
       return
     end
     rsvp = Rsvp.find(params[:rsvp_id])
     unless params[:validation_string] == rsvp.validation_string
       redirect_to '/'
     end

  end

  def update
  end

  def show
  end


end
