if Rails.env.development?
  SanitizeEmail::Config.configure do |config|
    config[:sanitized_to] =         'george@dewar.co.nz'

    # run/call whatever logic should turn sanitize_email on and off in this Proc:
    config[:activation_proc] =      Proc.new { %w(development test).include?(Rails.env) }
    config[:use_actual_email_prepended_to_subject] = true         # or false
    config[:use_actual_environment_prepended_to_subject] = true   # or false
    config[:use_actual_email_as_sanitized_user_name] = true       # or false
  end
end