# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twittabout_session',
  :secret      => '2578ea38f3398a5be98df749b487dd7f16b02120132c8ee4a8e7c4702084256e954bfbc1de76d6527df90fd0c8c3946fa1ea503d6d31ccf706162c0c8d0ad0ec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
