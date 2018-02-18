require 'httparty'

class Kele
include HTTParty

  def initialize(email, password)
    @base_uri = "https://www.bloc.io/api/v1"
    @auth_token = self.class.post(@base_uri + "/sessions", body: { "email": email, "password": password })
    
    p @auth_token
  end
end
