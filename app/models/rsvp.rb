class Rsvp < AWS::Record::Model
  AWS::Record.domain_prefix =  ENV['DOMAIN_PREFIX']

  string_attr :email
  string_attr :validation_string
  string_attr :people, :set => true
  integer_attr :parking_spaces
  timestamps



end