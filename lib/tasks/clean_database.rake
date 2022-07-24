# frozen_string_literal: true

namespace :clean_database do
  desc "Clear old data"

  task run: :environment do
    DatabaseCleaner.new.run
  end
end
