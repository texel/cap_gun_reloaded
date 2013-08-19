require 'etc'
require 'active_support/core_ext/integer/inflections'

module CapGun
  class Presenter
    DEFAULT_SENDER = %("CapGun" <cap_gun@example.com>)
    DEFAULT_EMAIL_PREFIX = "[DEPLOY]"
    
    attr_accessor :capistrano
    
    def initialize(capistrano)
      self.capistrano = capistrano
    end
    

    def recipients
      capistrano[:cap_gun_email_envelope][:recipients]
    end

    def email_prefix
      capistrano[:cap_gun_email_envelope][:email_prefix] || DEFAULT_EMAIL_PREFIX
    end

    def from
      capistrano[:cap_gun_email_envelope][:from] || DEFAULT_SENDER
    end
    
    def current_user
      Etc.getlogin
    end

    def summary
      %[#{capistrano[:application]} was #{deployed_to} by #{current_user} at #{release_time}.]
    end

    def deployed_to
      return "deployed to #{capistrano[:rails_env]}" if capistrano[:rails_env]
      "deployed"
    end

    def branch
      "Branch: #{capistrano[:branch]}" unless capistrano[:branch].nil? || capistrano[:branch].empty?
    end

    def git_details
      return unless capistrano[:scm].to_sym == :git
      <<-EOL
#{branch}
#{git_log}
      EOL
      rescue
        nil
    end

    def git_log
      "\nCommits since last release\n====================\n#{git_log_messages}"
    end

    def git_log_messages
      messages = `git log #{capistrano[:previous_revision]}..#{capistrano[:latest_revision]} --pretty="format:%h:%s\ [%an]"`
      exit_code.success? ? messages : "N/A"
    end
    
    def exit_code
      $?
    end
    
    # Gives you a prettier date/time for output from the standard Capistrano timestamped release directory.
    # This assumes Capistrano uses UTC for its date/timestamped directories, and converts to the local
    # machine timezone.
    def humanize_release_time(path)
      return unless path
      match = path.match(/(\d+)$/)
      return unless match
      local = convert_from_utc(match[1])
      local.strftime("%B #{local.day.ordinalize}, %Y %l:%M %p #{local_timezone}").gsub(/\s+/, ' ').strip
    end
    
    def present_time(time)
      time.strftime("%B #{time.day.ordinalize}, %Y %l:%M %p #{local_timezone}").gsub(/\s+/, ' ').strip
    end
    
    # Use some DateTime magicrey to convert UTC to the current time zone
    # When the whole world is on Rails 2.1 (and therefore new ActiveSupport) we can use the magic timezone support there.
    def convert_from_utc(timestamp)
      # we know Capistrano release timestamps are UTC, but Ruby doesn't, so make it explicit
      utc_time = timestamp << "UTC" 
      datetime = DateTime.parse(utc_time)
      datetime.new_offset(local_datetime_zone_offset)
    end
    
    def local_datetime_zone_offset
      @local_datetime_zone_offset ||= DateTime.now.offset
    end
    
    def local_timezone
      @current_timezone ||= Time.now.zone
    end
    
    def release_time
      present_time(Time.now)
    end
    
    def previous_release_time 
      humanize_release_time(capistrano[:previous_release])
    end

    def subject
      "#{email_prefix} #{capistrano[:application]} #{deployed_to}"
    end
    
    def comment
      "Comment: #{capistrano[:comment]}.\n" if capistrano[:comment]
    end

    def body
<<-EOL
#{summary}
#{comment}
Deployment details
==================
Current Branch: #{capistrano[:current_revision]}

Release Revision: #{capistrano[:latest_revision]}
Previous Release Revision: #{capistrano[:previous_revision]}

Repository: #{capistrano[:repository]}
Deploy path: #{capistrano[:deploy_to]}
Domain: #{capistrano[:domain]}
#{git_details}
EOL
    end

  end
end
