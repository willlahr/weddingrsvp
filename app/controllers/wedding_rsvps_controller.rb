class WeddingRsvpsController < ApplicationController
  def index

  end

  def new
    @title = (params['change']) ? 'Change RSVP' : 'New RSVP'

  end

  def create


    #Rsvp.create_domain
    #Person.create_domain

    # see if email exists find
    existing_rsvp = Rsvp.where(:email => params[:email])
    if existing_rsvp.count > 0
      puts 'Existing RSVP'
      rsvp = existing_rsvp.first
      redirect_to email_verify_wedding_rsvp_path(rsvp_id: rsvp.id)


    else

      if params[:change] != ''
        redirect_to '/'
        flash[:notice] = "I didn't find any records for that email address"
        return
      end

      puts 'New RSVP needed'
      rsvp = Rsvp.new
      person = Person.new

      rsvp.email = params[:email]
      rsvp.validation_string = SecureRandom.hex(20)
      rsvp.save
      person.rsvp_id = rsvp.id
      person.save

      rsvp.people = [ person.id ]
      rsvp.save

      sleep 2

      redirect_to edit_wedding_rsvp_path(rsvp_id: rsvp.id, validation_string: rsvp.validation_string)
    end

  end

  def email_verify

  end

  def send_edit_link
    @rsvp = Rsvp.find(params[:rsvp_id])

    RsvpMailer.change_details(@rsvp).deliver

    redirect_to edit_link_thanks_wedding_rsvp_path(rsvp_id: params[:rsvp_id])

  end

  def edit_link_thanks
    @rsvp = Rsvp.find(params[:rsvp_id])
    # TaxiMailer.forgotten_password(@email, @host).deliver
    @email = @rsvp.email

  end


  def ajax_new_person
    unless params[:rsvp_id] && params[:validation_string]
      render text: ''
      return
    end

    begin
      @rsvp = Rsvp.find(params[:rsvp_id])
    rescue
      sleep 4
      @rsvp = Rsvp.find(params[:rsvp_id])
    end

    unless params[:validation_string] == @rsvp.validation_string
      render text: ''
      return
    end

    @person = Person.new
    @person
    render :layout => false
  end

  def edit

    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end

    begin
      @rsvp = Rsvp.find(params[:rsvp_id])
    rescue
      sleep 4
      @rsvp = Rsvp.find(params[:rsvp_id])
    end

    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end

  end

  def update
  end

  def show
  end


end
