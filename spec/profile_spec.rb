require 'rest-client'
require 'json'
require 'pry'

RSpec.describe 'Profile endpoint' do
  let(:registration_base_url) { 'http://dev-api.lebaraplay.com/api/v1/users' }
  let(:authentication_base_url) { 'http://dev-api.lebaraplay.com/api/oauth/token' }
  let(:profile_base_url) { 'http://dev-api.lebaraplay.com/api/v1/user' }
  let(:valid_username) { "apitester#{SecureRandom.uuid}@acme.com" }
  let(:password) { 'password' }
  let(:required_params) { 'client_id=spbtv-interview&client_version=0.1.0&locale=en_GB&timezone=0' }
  let(:valid_registration_url) { "#{registration_base_url}?#{required_params}&username=#{valid_username}&password=#{password}" }
  let(:required_authentication_param) { 'grant_type=password' }
  let(:valid_authentication_url) do
    "#{authentication_base_url}?#{required_params}&#{required_authentication_param}&username=#{valid_username}&password=#{password}"
  end
  let(:valid_profile_url) { "#{profile_base_url}?#{required_params}" }

  def register_user
    RestClient.post valid_registration_url, {}
  end

  def authentication_token
    register_user

    authentication_response = RestClient.post valid_authentication_url, {}
    response_body = JSON.parse(authentication_response.body)
    response_body['access_token']
  end

  let(:authorization_header) { { Authorization: "bearer #{authentication_token}" } }

  xit 'should return user profile' do
    begin
      RestClient.get valid_profile_url, authorization_header
    rescue => e
      require 'pry'; binding.pry
    end
  end
end
