# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { 'Geoffrey' }
    last_name  { 'Chaucer' }
    additional_information { 'Some extra info' }
  end
end
