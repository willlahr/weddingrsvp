class Person  < AWS::Record::Model
  AWS::Record.domain_prefix = ENV['DOMAIN_PREFIX']

  boolean_attr :made_rsvp
  string_attr :first_name
  string_attr :last_name
  string_attr :attending
  integer_attr :age
  string_attr :rsvp_id
  string_attr :message
  string_attr :food_choice
  string_attr :food_comments
  string_attr :size
  timestamps


end