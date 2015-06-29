require 'rest-client'
require 'json'
require 'pry'

RSpec.describe 'Authentication endpoint' do
  let(:registration_base_url) { 'http://dev-api.lebaraplay.com/api/v1/users' }
  let(:authentication_base_url) { 'http://dev-api.lebaraplay.com/api/oauth/token' }
  let(:valid_username) { "apitester#{SecureRandom.uuid}@acme.com" }
  let(:password) { 'password' }
  let(:required_params) { 'client_id=spbtv-interview&client_version=0.1.0&locale=en_GB&timezone=0' }
  let(:valid_registration_url) { "#{registration_base_url}?#{required_params}&username=#{valid_username}&password=#{password}" }
  let(:required_authentication_param) { 'grant_type=password' }
  let(:valid_authentication_url) do
    "#{authentication_base_url}?#{required_params}&#{required_authentication_param}&username=#{valid_username}&password=#{password}"
  end

  it 'should return access token for valid user' do
    RestClient.post valid_registration_url, {}
    response = RestClient.post valid_authentication_url, {}

    expect(response.code).to eq(200)
    response_body = JSON.parse(response.body)
    expect(response_body['token_type']).to eq('bearer')
    expect(response_body['access_token']).not_to be_empty
  end

  xit 'should fail for unknown user'
  xit 'should fail if password is wrong'
  xit 'should fail when required parameters are omitted'
end
