# frozen_string_literal: true

require "rake"
RSpec.configure do |config|
  config.before(:suite) do
    # Rails.application.load_tasks # Load all the tasks just as Rails does (`load 'Rakefile'` is another simple way)
    load "Rakefile"
  end

  config.before(:each) do
    Rake.application.tasks.each(&:reenable) # Remove persistency between examples
  end
end
