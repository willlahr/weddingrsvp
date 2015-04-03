class RsvpMailer < ApplicationMailer
  default from: 'wedding-bot@pterowedding.info'
  layout 'mailer'

  def change_details(rsvp)
    @rsvp = rsvp
    mail(  :to => @rsvp.email , :subject => "Change your RSVP for Will & Roz's wedding")


  end

end
