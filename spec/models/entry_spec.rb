# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject(:entry) { build(:entry) }

  describe 'Factory' do
    it 'is valid with valid attributes' do
      expect(entry).to be_valid
    end
  end
end
