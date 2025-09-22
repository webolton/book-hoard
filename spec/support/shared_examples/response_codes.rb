# frozen_string_literal: true

shared_context 'a successful request' do
  it 'should respond with a 200 OK status code' do
    do_action
    expect(response).to have_http_status(200)
  end
end
