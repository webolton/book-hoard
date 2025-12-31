# frozen_string_literal: true

class Entry < ApplicationRecord
  has_many :authors, through: :authors_entries

  enum :type, { book: 0, article: 1, manuscript: 3, notes: 4, book_review: 5 }
end
