# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    additional_information { Faker::Lorem.sentence(word_count: 4) }
  end

  factory :entry do
    full_title { Faker::Book.title }
    publication_date { Date.current - rand(2..200).years }
    start_page { rand(2..4) }
    end_page { rand(5..10) }
    start_folio { rand(5..10) }
    start_side { 'recto' }
    end_folio { rand(5..10) }
    end_side { 'verso' }
    type { :book }
    isbn { Faker::Code.isbn(base: 10) }
    isbn13 { Faker::Code.isbn(base: 13) }
    format { 'print' }
    language { 'en' }
    publisher { 'University of Pennsylvania' }
    file_location { 'path/to/cool/item' }
    volume { 2 }
    series { 'Extra Series' }
    notes { 'Some extra information' }
  end
end
