client = ZendeskAPI::Client.new do |config|
  # Mandatory:
  config.url = "<- your-zendesk-url ->" # e.g. https://mydesk.zendesk.com/api/v2

  # Basic / Token Authentication
  config.username = "login.email@zendesk.com"

  # Choose one of the following depending on your authentication choice
  config.token = "your zendesk token"
  config.password = "your zendesk password"

  # OAuth Authentication
  config.access_token = "your OAuth access token"

  # Optional:

  # Retry uses middleware to notify the user
  # when hitting the rate limit, sleep automatically,
  # then retry the request.
  config.retry = true
end


# This script will merge one tag into another, including updating all tickets with the old tag
# to have the new tag.
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
