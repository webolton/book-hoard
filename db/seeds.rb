# frozen_string_literal: true

require 'faker'

return if ENV.fetch('APP_ENV', nil) == 'production'

Author.destroy_all

50.times do |time|
  full_name_parts = Faker::Name.unique.name.split
  Author.create!(first_name: full_name_parts[0], last_name: full_name_parts[1])
end
