# frozen_string_literal: true

class EntriesController < ApplicationController
  def new
    @types = Entry.types.keys
    @entry = Entry.new
  end
end
