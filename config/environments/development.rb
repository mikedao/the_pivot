Rails.application.configure do

  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.delivery_method = :sendmail

  config.action_mailer.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
    :enable_starttls_auto => true, # detects and uses STARTTLS
    :user_name => "michael.dao@gmail.com",
    :password  => ENV["PIVOT_MANDRILL"], # smtp password is any valid api key
    :authentication => 'login' # Mandrill supports 'plain' or 'login'
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

#   config.paperclip_defaults = {
#   :storage => :s3,
#   :s3_credentials => {
#     # :bucket => ENV['S3_BUCKET_NAME'],
#     # :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
#     # :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
#     :bucket => "keevahh",
#     :access_key_id => "AKIAJIILKBVLDFXBGNMA",
#     :secret_access_key => "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"
#   }
# }
end
