# frozen_string_literal: true

class EntriesController < ApplicationController
  def new
    @entry = Entry.new
  end
end
