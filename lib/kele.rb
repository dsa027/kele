require 'httparty'
require './lib/roadmap'
require 'awesome_print'

class Kele
  include HTTParty
  include Roadmap
  include AwesomePrint

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
  
  def get_me
    response = self.class.get(@base_uri + "/users/me", headers: {"authorization": @auth_token}).body

    return JSON.parse(response)
  end
  
  def get_mentor_availability(id)#2363254
    response = self.class.get(@base_uri + "/mentors/#{id}/student_availability", headers: {"authorization": @auth_token}).body

    return JSON.parse(response).to_a
  end
end
