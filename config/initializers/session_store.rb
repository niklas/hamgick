# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_haimg_session',
  :secret      => '5170d3df611415f2b58c00c52fd1997171f0eefcf6f1b2fafbe0f316d18cc5b593d3122bd5d3e2f84f4bde2af8a9f3cc1f8f49cb4283e6733ea520d7a83d75fb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
