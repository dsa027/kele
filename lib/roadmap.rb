module Roadmap
  def get_roadmap(id)#37
    response = self.class.get(@base_uri + "/roadmaps/#{id}", headers: {"authorization": @auth_token}).body

    return JSON.parse(response)
  end
  
  def get_checkpoint(id)#2123
    response = self.class.get(@base_uri + "/checkpoints/#{id}", headers: {"authorization": @auth_token}).body

    return JSON.parse(response)
  end
  
  def get_messages(page = nil) 
    if page.nil? 
      return get_all_messages
    else
      response = self.class.get(@base_uri + "/message_threads", body: {"page": page}, headers: {"authorization": @auth_token}).body
      
      return JSON.parse(response["items"])
    end
  end
  
  def get_all_messages 
    count = -1 # how many messages there are to retrieve
    page = 1   # page to retrieve
    all_messages = []
    
    loop do 
      response = self.class.get(@base_uri + "/message_threads", body: {"page": page}, headers: {"authorization": @auth_token}).body
      response = JSON.parse(response)
      count = response["count"].to_i if count == -1  # if not populated, get total message count
      messages = response["items"]
      
      all_messages << messages                  # add these messages to all_messages
      count -= messages.length                  # decrement the number of messages to retrieve
      page += 1                                 # next page to retrieve

      break if count <= 0
    end
    
    return all_messages.flatten
  end
  
  def create_message(from, to_id, subject, msg) #2403183
    response = self.class.post(@base_uri + "/messages", body: {"sender": from, "recipient_id": to_id, "subject": subject, "stripped-text": msg}, headers: {"authorization": @auth_token})

    return response
  end
end
