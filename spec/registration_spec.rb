require 'rest-client'
require 'json'
require 'pry'

RSpec.describe 'Registration endpoint' do
  let(:base_url) { 'http://dev-api.lebaraplay.com/api/v1/users' }
  let(:valid_username) { "apitester#{SecureRandom.uuid}@acme.com" }
  let(:password) { 'password' }
  let(:required_params) { 'client_id=spbtv-interview&client_version=0.1.0&locale=en_GB&timezone=0' }
  let(:valid_registration_url) { "#{base_url}?#{required_params}&username=#{valid_username}&password=#{password}" }

  it 'should register user with correct parameters' do
    response = RestClient.post valid_registration_url, {}
    expect(response.code).to eq(201)
    expect(response.body).to eq(%({"meta":{"status":201}}))
  end

  it 'should return error on non unique username' do
    begin
      2.times { RestClient.post valid_registration_url, {} }
    rescue => e
      expect(e.response.code).to eq(400)
      response_body = JSON.parse(e.response.body)['meta']
      expect(response_body['error_type']).to eq('non_unique_param')
      expect(response_body['error_param']).to eq('username')
      expect(response_body['error_message']).to match(/^customer already registered/)
      #expect(response_body).to have_key('error_id') # It is absent at the moment
    end
  end

  it 'should fail when required params are missing'
  xit 'should fail on wrong username format'
end
