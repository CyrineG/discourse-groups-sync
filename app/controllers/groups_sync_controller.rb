
class GroupsSyncController < ApplicationController
  skip_before_action :check_xhr
  
  def index
    file = File.read(File.dirname(__FILE__)+ '/ldap.json')
    data = JSON.parse(file)
    render json: {response: sync_group(data)}
  end
  
  private
  
  # ------sync_group(data)------
  # description: main meth. Synchronises discourse group with ldap group
  # takes data (String hash received from ldap.json) of group as param
    
    def sync_group(data)
      
      users_array = get_users(data)
      group_id = get_group_id(data["name"])
      users_array.each do |user|
        add_user_group(group_id, user["username"])
      end
     
      "users added!"
    end

  # ------get_users(group)------
  #description: gets a group's users from our ldap.json file --> to be changed by fct  that gets a group's users from actual ldap
  # takes group (String hash) as parameter
  # returns users (String hash)
  
    def get_users(group) 
      group['users'].each {|user| puts user['name']}
    end
   
  # ------get_group_id(group_name)------
  # description: gets a discourse group's id
  # takes the group's name (String) as param
  # returns the group_id (String)
  
    def get_group_id(group_name)
      group = Group.find_by name: group_name
      group.id
    end
   
  # ------get_user_discourse(user_name)------  
  # description: fetches a user from discourse
  # takes user's username (String) as param
  # returns a user (User)
  
    def get_user_discourse(user_name)
      user = User.find_by(username: user_name)
      user
    end
    
  # ------add_user_group(group_id, user_name)------
  # description: adds a user to the discourse group
  # takes discourse group_id (String) and user username (String) as params
  # doesn't return anything
  
    def add_user_group(group_id, user_name)
      group = Group.find(group_id)
      if group
        user = get_user_discourse(user_name)
        if user
          #if user isn't already in group, add user
          if !GroupUser.find_by(group_id: group.id, user_id: user.id)
            group.add(user)
          end
        end
      end
    end
    
    
end

