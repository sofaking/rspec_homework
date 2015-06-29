require 'rest-client'
require 'pry'

RSpec.describe 'Registration endpoint' do
  let(:base_url) { 'http://dev-api.lebaraplay.com/api/v1/users' }
  let(:valid_username) { "apitester#{SecureRandom.uuid}@acme.com" }
  let(:password) { 'password' }
  let(:required_params) { 'client_id=spbtv-interview&client_version=0.1.0&locale=en_GB&timezone=0' }

  it 'should register user with correct parameters' do
    url = "#{base_url}?#{required_params}&username=#{valid_username}&password=#{password}"

    result = RestClient.post url, {}
    expect(result.body).to eq(%({"meta":{"status":201}}))
  end

  it 'should return error on non unique username'
  it 'should fail when required params are missing'
  xit 'should fail on wrong username format'
end
