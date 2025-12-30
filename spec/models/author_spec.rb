# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it {
      should validate_uniqueness_of(:first_name)
        .scoped_to(:last_name)
        .with_message('Full author name already used')
    }

    context 'when the first_name and last_name are missing' do
      let(:author) { build(:author, first_name: nil, last_name: nil) }
      it 'validates presence of both fields' do
        expect(author).not_to be_valid
        expect(author.errors[:first_name]).to include("can't be blank")
        expect(author.errors[:last_name]).to include("can't be blank")
        expect(author.errors[:base]).to include('Either first name or last name must be present.')
      end
    end
  end
end
