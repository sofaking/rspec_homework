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

  def register_user
    RestClient.post valid_registration_url, {}
  end

  it 'should return access token for valid user' do
    register_user
    response = RestClient.post valid_authentication_url, {}

    expect(response.code).to eq(200)
    response_body = JSON.parse(response.body)
    expect(response_body['token_type']).to eq('bearer')
    expect(response_body['access_token']).not_to be_empty
  end

  it 'should fail for unknown user' do
    register_user
    authentication_url_with_unknown_username =
      "#{authentication_base_url}?#{required_params}&#{required_authentication_param}&username=unknown_user@acme.com&password=#{password}"

    RestClient.post(authentication_url_with_unknown_username, {}) do |response|
      expect(response.code).to eq(401)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('invalid_client')
      expect(response_body['error_description']).to eq('Incorrect username or password')
    end
  end

  it 'should fail if password is wrong' do
    register_user
    authentication_url_with_wrong_password =
      "#{authentication_base_url}?#{required_params}&#{required_authentication_param}&username=#{valid_username}&password=wrong_one"

    RestClient.post(authentication_url_with_wrong_password, {}) do |response|
      expect(response.code).to eq(401)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('invalid_client')
      expect(response_body['error_description']).to eq('Incorrect username or password')
    end
  end

  it 'should fail when required parameters are omitted' do
    register_user
    url_with_required_param_omitted = "#{authentication_base_url}?#{required_params}&username=#{valid_username}&password=#{password}"

    RestClient.post(url_with_required_param_omitted, {}) do |response|
      expect(response.code).to eq(400)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('authentication_required')
      expect(response_body['error_description']).to eq('Cannot determine authentication method')
    end
  end
end
