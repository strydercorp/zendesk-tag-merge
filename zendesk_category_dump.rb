require 'zendesk_api'
require 'yaml'
require 'awesome_print'
require "highline/import"
require 'csv'

config_options = YAML.load_file('config.yml')

client = ZendeskAPI::Client.new do |config|
  config.url = config_options["url"]
  config.username = config_options["username"]
  config.token = config_options["token"]
end

# if ENV['custom_field_id']
  # custom_field_id = ENV['custom_field_id']
# else
  # puts "Please enter the custom field id: "
  # custom_field_id = gets
# end
custom_field_id = 35673307

ticket_field = client.ticket_fields.find!(id: custom_field_id)
data = ticket_field.custom_field_options.map{|x| [x["name"],x["value"]]}
CSV.open("categories.csv", "wb") do |csv|
  data.each do |row|
    csv  << row
  end
end
# ap "Ticket Field Name: #{ticket_field.title}"
# unless HighLine.agree "Is this the correct ticket field?"
  # ap "Please enter the correct field id (you can also use an env variable custom_field_id)"
  # exit
# end

# old_value = "boston_university_school_of_public_health"
# new_value = "154"
# tickets = client.search(query: "fieldvalue:#{old_value}")

# tickets.all! do |ticket|
  # fields = ticket.custom_fields
  # field = fields.select { |field| field["id"] == custom_field_id.to_i }.first
  # unless field["value"] == old_value
    # ap "ticket previous value did not match expectations, skipping"
    # next
  # end
  # field["value"] = new_value

  # ticket.custom_fields = fields
  # if ticket.save
    # puts "Updated ticket #{ticket.id}"
  # else
    # # puts "Failed to save"
    # # puts ticket.errors
  # end
# end

# This script will update all tickets custom field value from one thing to anther. This will help
# us merge tags, or rename custom field tags
# # Ask for old tag
# # Ask for new tag
# If either doesn't exist, suggest renaming
#   return
# Query search all matching old tag, store
# Query search all matching new tag, store
# "There are 500 tickets with the tag X, and 800 tickets with the tag Y"
# "After this merge there will be 0 tickets with the tag X and 1300 tickets with the tag Y and X will be removed as an option"
# "Confirm"
# return if not confirmed
# Otherwise for each old tag result, add new tag
# Now search to see for {old tag and new tag} and make sure count == old tag count
# Now remove old tag from the system including from tickets - or rename to ARCHIVED + tag name
