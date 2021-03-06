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
      response
    end
  end
  
  def get_me
    response = self.class.get(@base_uri + "/users/me", headers: {"authorization": @auth_token}).body

    JSON.parse(response)
  end
  
  def get_mentor_availability(id)
    response = self.class.get(@base_uri + "/mentors/#{id}/student_availability", headers: {"authorization": @auth_token}).body

    JSON.parse(response).to_a
  end
  
  def get_messages(page = nil) 
    if page.nil? 
      get_all_messages
    else
      response = self.class.get(@base_uri + "/message_threads", body: {"page": page}, headers: {"authorization": @auth_token}).body
      
      JSON.parse(response["items"])
    end
  end
  
  def get_all_messages 
    count = -1
    page = 1  
    all_messages = []
    
    loop do 
      response = self.class.get(@base_uri + "/message_threads", body: {"page": page}, headers: {"authorization": @auth_token}).body
      response = JSON.parse(response)
      count = response["count"].to_i if count == -1
      messages = response["items"]
      
      all_messages << messages                  
      count -= messages.length                  
      page += 1                                 

      break if count <= 0
    end
    
    all_messages.flatten
  end
  
  def create_message(from, to_id, subject, msg)
    response = self.class.post(@base_uri + "/messages", body: {"sender": from, "recipient_id": to_id, "subject": subject, "stripped-text": msg}, headers: {"authorization": @auth_token}).body

    JSON.parse(response)

  end
  
  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post(@base_uri + "/checkpoint_submissions", body: {"assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment, "enrollment_id": enrollment_id}, headers: {"authorization": @auth_token}).body

    JSON.parse(response)  
  end
end
