require 'httparty'

class Kele
include HTTParty

  def initialize(email, password)
    values = {
      "email": "#{email}",
      "password": "#{password}"
    }
    @base_uri = "https://www.bloc.io/api/v1"
    @auth_token = self.class.post(@base_uri, values)
  end
end
