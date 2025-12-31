# frozen_string_literal: true

class EntriesController < ApplicationController
  def new
    @types = Entry.types.keys
    @entry = Entry.new
    @entry.authors_entries.build
  end

  private

  def entry_params
    params.require(:entry).permit(:full_title, :type, :publication_date,
                                  authors_entries_attributes: %i[author_id id _destroy])
  end
end
