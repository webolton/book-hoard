# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'New entry page', type: :feature do
  describe 'when a user visits the new entry page' do
    scenario 'has the correct static content' do
      visit root_path

      click_link('New entry')

      expect(page).to have_content 'New entry'
    end
  end
end
