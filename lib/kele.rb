require 'httparty'

class Kele
include HTTParty

  def initialize(email, password)
    begin
      @base_uri = "https://www.bloc.io/api/v1"
      response = self.class.post(@base_uri + "/sessions", body: { "email": email, "password": password })

      @auth_token = response["auth_token"]
      raise "AuthorizationError" if @auth_token.empty?
      
    rescue
      puts "Invalid email or password: Auth Token not returned."
    end
  end
end
