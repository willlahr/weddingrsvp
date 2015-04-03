class Rsvp < AWS::Record::Model
  AWS::Record.domain_prefix =  ENV['DOMAIN_PREFIX']

  string_attr :email
  string_attr :validation_string
  string_attr :people, :set => true
  integer_attr :parking_spaces
  timestamps

  def edit_url
    "http://rsvp.pterowedding.info/wedding_rsvp/edit?rsvp_id=#{self.id}&validation_string=#{self.validation_string}"
  end

end