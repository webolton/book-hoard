# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :entries, through: :authors_entries

  validates :first_name, presence: true, unless: ->(author) { author.last_name.present? }
  validates :last_name, presence: true, unless: ->(author) { author.first_name.present? }

  validates :first_name,
            uniqueness: { scope: :last_name,
                          message: 'Full author name already used' }
end
