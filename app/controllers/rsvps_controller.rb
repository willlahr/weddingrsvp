class RsvpsController < ApplicationController
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
      redirect_to email_verify_rsvp_path(rsvp_id: rsvp.id)


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
      person.made_rsvp=true
      person.save

      rsvp.people = [ person.id ]
      rsvp.save

      sleep 2

      redirect_to edit_rsvp_path(rsvp_id: rsvp.id, validation_string: rsvp.validation_string)
    end

  end

  def email_verify

  end

  def send_edit_link
    @rsvp = Rsvp.find(params[:rsvp_id])

    RsvpMailer.change_details(@rsvp).deliver

    redirect_to edit_link_thanks_rsvp_path(rsvp_id: params[:rsvp_id])

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
    @name = "+#{params[:index]}"
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
    @rsvp = Rsvp.find(params[:rsvp_id])
    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end
    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end
    params['person'].each do |key, person|
      if person['id'] && person['id'] != ''
        @person = Person.find(person['id'])
      else
        @person =  Person.new
        @person.rsvp_id = @rsvp.id

      end


      @person.first_name =person['first_name'] if person['first_name']
      @person.last_name = person['last_name'] if person['last_name']
      @person.attending = person['attending'] if person['attending']
      @person.message =   person['message']   if person['message']
      @person.size  =     person['size']      if person['size']
      @person.age   =     person['age']       if person['age']

      @person.save
      @rsvp.people = @rsvp.people + [ "#{@person.id}" ] unless @rsvp.people.include? @person.id
      @rsvp.save

    end
    sleep 2
    redirect_to food_rsvp_path(rsvp_id: @rsvp.id, validation_string: @rsvp.validation_string)


  end

  def food
    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end
    @rsvp = Rsvp.find(params[:rsvp_id])

    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end

    attending = 0
    @people_list = []
    @rsvp.people.each do |person_id|
      person = Person.find(person_id)
      if person.attending == "yes"
        @people_list << person
      end

    end

    if @people_list.length == 0
      redirect_to final_thanks_rsvp_path
    end



  end

  def update_food
    @rsvp = Rsvp.find(params[:rsvp_id])
    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end
    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end

    if params['person']
      params['person'].each do |id, person|
        @person = Person.find(id)
        @person.food_choice = person['food_choice']
        @person.food_comments = person['food_comments']
        @person.save
      end
    end
    redirect_to camping_parking_rsvp_path(rsvp_id: @rsvp.id, validation_string: @rsvp.validation_string)

  end



  def camping_parking
    @rsvp = Rsvp.find(params[:rsvp_id])
    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end
    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end

  end

  def update_camping_parking
    @rsvp = Rsvp.find(params[:rsvp_id])
    unless params[:rsvp_id] && params[:validation_string]
      redirect_to '/'
      return
    end
    unless params[:validation_string] == @rsvp.validation_string
      redirect_to '/'
    end

    @rsvp.parking_spaces = params[:parking_spaces] if params[:parking_spaces]
    @rsvp.hired_tents = params[:hired_tents] if  params[:hired_tents]
    @rsvp.own_tents = params[:own_tents] if params[:own_tents]

    @rsvp.save
    sleep 2

    redirect_to final_thanks_rsvp_path(rsvp_id: @rsvp.id, validation_string: @rsvp.validation_string)

  end

  def show
  end

  def final_thanks

  end

  def download_info

  end

  def csv

    unless params[:password] &&  params[:password] == ENV['DOWNLOAD_PASSWORD']
      logger.debug "attempted password: #{params[:password]}, correct password #{ENV['DOWNLOAD_PASSWORD']}"
      redirect_to download_info_rsvp_path
      return
    end

    csv_text = 'attending, email, first name, last name, size, age, food choice, food comments,excuse,parking spaces,rented_tents,own tents'

    Person.each do |person|
      if person.made_rsvp
        rsvp = Rsvp.find person.rsvp_id
      else
        rsvp = nil
      end
      csv_text << "#{person.attending},"

      if rsvp
        csv_text << "#{rsvp.email},"
      else
        csv_text << ','
      end
      csv_text << "#{person.first_name},#{person.last_name},#{person.size},#{person.age},#{person.food_choice},#{person.food_comments},#{person.message},"

      if rsvp
        csv_text << "#{rsvp.parking_spaces},#{rsvp.hired_tents},#{rsvp.own_tents}"
      else
        csv_text << ',,'
      end
      csv_text << "\n"
    end

    headers['Content-Disposition'] = "attachment; filename=\"wedding.csv\""
    render text: csv_text, mime_type: 'text/csv'

  end
end
