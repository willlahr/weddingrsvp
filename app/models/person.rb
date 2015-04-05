class Person  < AWS::Record::Model
  AWS::Record.domain_prefix = ENV['DOMAIN_PREFIX']

  boolean_attr :made_rsvp
  string_attr :first_name
  string_attr :last_name
  boolean_attr :attending
  integer_attr :age
  string_attr :rsvp_id
  string_attr :message
  string_attr :size
  timestamps


end