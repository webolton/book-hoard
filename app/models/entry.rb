# frozen_string_literal: true

class Entry < ApplicationRecord
  has_many :authors, through: :authors_entries
  has_many :authors_entries, dependent: :destroy

  accepts_nested_attributes_for :authors_entries, allow_destroy: true

  enum :type, { book: 0, article: 1, manuscript: 3, notes: 4, book_review: 5 }
end
