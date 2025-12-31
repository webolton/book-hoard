# frozen_string_literal: true

class AuthorsEntry < ApplicationRecord
  self.table_name = 'authors_entries'

  belongs_to :author
  belongs_to :entry
end
