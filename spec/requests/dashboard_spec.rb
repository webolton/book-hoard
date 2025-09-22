# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'dashboard', type: :request do
  describe 'root page' do
    subject(:do_action) { get root_path }

    it_behaves_like 'a successful request'
  end
end
