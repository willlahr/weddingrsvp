class Person  < AWS::Record::Model
  AWS::Record.domain_prefix = ENV['DOMAIN_PREFIX']

  boolean_attr :made_rsvp
  string_attr :name
  boolean_attr :child
  integer_attr :age
  string_attr :rsvp_id
  timestamps


end