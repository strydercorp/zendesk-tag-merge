# Make sure config.yml is set up
# Make sure schools.csv is present in your working directory, csv format, no header, id,name
# Make sure you have updated custom_field_id below to be your field
custom_field_id = '35272127'

require 'zendesk_api'
require 'yaml'
require 'csv'
require 'awesome_print'
require "highline/import"

config_options = YAML.load_file('config.yml')

client = ZendeskAPI::Client.new do |config|
  config.url = config_options["url"]
  config.username = config_options["username"]
  config.token = config_options["token"]
end

ticket_field = client.ticket_fields.find!(id: custom_field_id)
current_options = ticket_field.custom_field_options.map{ |option| { "name" => option.name, "value" => option.value } }

new_options = CSV.read("schools.csv").map{ |x| { "name" => x[1], "value" => x[0] }}

all_options = (current_options + new_options)

puts ""
puts "Ticket Field Name: #{ticket_field.title}"
puts "#{current_options.length} options currently in zendesk"
puts "#{new_options.length} options to be added"
puts "#{all_options.length} will exist after this is done"
puts ""

exit unless HighLine.agree "Are you sure you want to do this?"

ticket_field.custom_field_options = all_options
ticket_field.save

# # Getting way too fancy here - this works (does a diff based on values, would let us always have a clean list)
# # but it'd require fucking up a lot of old data
# # Instead, going to just append new schools to the current list
# ap "Ticket Field Name: #{ticket_field.title}"
# ap "Current # of options: #{current_options.count}"
# unless HighLine.agree "Is this the correct ticket?"
  # ap "Please update this file to point to the right ticket"
  # exit
# end

# new_options = CSV.read("schools.csv").map{ |x| { "name" => x[1], "value" => x[0] }}

# # ap current_options
# # ap new_options
# options_being_removed = current_options.keep_if { |current| !new_options.any? { |new| new["value"] == current["value"] } }
# options_being_added = new_options.keep_if { |new| !current_options.any? { |current| new["value"] == current["value"] } }

# if options_being_removed.length > 0
  # ap options_being_removed
  # ap "#{options_being_removed.length} above options will be removed since they are no longer present in schools.csv"
  # exit unless HighLine.agree "Are you sure you want these removed? y/n"
# end

# if options_being_added.length > 0
  # ap options_being_added
  # ap "#{options_being_added.length} above options will be added since they are new in schools.csv"
  # exit unless HighLine.agree "Are you sure you want these added? y/n"
# end

# ticket_field.custom_field_options = new_options
# ticket_field.save
