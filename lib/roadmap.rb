module Roadmap
  def get_roadmap(id)#37
    response = self.class.get(@base_uri + "/roadmaps/#{id}", headers: {"authorization": @auth_token}).body

    return JSON.parse(response)
  end
  
  def get_checkpoint(id)#2123
    response = self.class.get(@base_uri + "/checkpoints/#{id}", headers: {"authorization": @auth_token}).body

    return JSON.parse(response)
  end
end
