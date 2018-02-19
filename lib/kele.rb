require 'httparty'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

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
    @me = JSON.parse(response)
  end
  
  def get_mentor_availability(id)#2363254
    response = self.class.get(@base_uri + "/mentors/#{id}/student_availability", headers: {"authorization": @auth_token}).body
    @mentor_avail = JSON.parse(response).to_a
  end
  
  def puts_v(array) 
    array.each do |v|
      if v.is_a?(Hash)
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> v is a HASH"
        puts_kv(v)
      else
        puts "@@@@@@@@@@@@@@@@@@@ #{v}"
      end
    end
  end
  
  def puts_kv(hash)
    hash.each do |k, v| 
      if v.is_a?(Hash)
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{k} = "
        puts_kv(v)
      elsif v.is_a?(Array)
        puts "@@@@@@@@@>>>>>>@@@@@@@@@@@@>>>>>>>>>>>>@@@@@@@@@@ #{k}"
        puts_v(v)
      else
        puts ">>>>>>>>>>>>>>>>>>> #{k} = #{v}"
      end
    end
  end
end
