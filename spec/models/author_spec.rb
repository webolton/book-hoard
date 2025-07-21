# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    let(:author) { create(:author) }

    it 'has a valid factory' do
      expect(author).to be_valid
    end

    context 'when both the first and last name are missing' do
      it 'raises the correct ActiveRecord error' do
        expect do
          Author.create!
        end.to raise_error(ActiveRecord::RecordInvalid,
                           'Validation failed: First name can\'t be blank, Last name can\'t be blank')
      end
    end

    context 'when at least the last name is provided' do
      it 'creates an author' do
        expect { Author.create!(last_name: 'Spock') }.to change { Author.count }.by(1)
      end
    end
  end
end
