# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :entries, through: :authors_entries

  validates :first_name, presence: true, unless: ->(author) { author.last_name.present? }
  validates :last_name, presence: true, unless: ->(author) { author.first_name.present? }
end
