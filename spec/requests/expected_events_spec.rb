require 'rails_helper'

describe "Expected events", :type => :request do
  context 'as an API consumer' do
    before do
      @api_token = FactoryGirl.create(:remote_side).api_token
    end

    context 'using the JSON format' do
      let(:authentication) { { api_token: @api_token } }
      let(:accept_headers) { { 'Content-Type' => 'application/json' } }

      it 'creates an incoming event' do
        json = authentication.merge(incoming_event: { title: 'Foo' }).to_json
        post '/incoming_events.json', params: json, headers: accept_headers
        expect(response.code).to eql "201"
      end
    end
  end
end
