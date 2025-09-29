# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'entries', type: :request do
  describe '#new' do
    subject(:do_action) { get new_entry_path }

    it_behaves_like 'a successful request'
  end
end
