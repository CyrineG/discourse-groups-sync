# frozen_string_literal: true

class GroupsSyncController < ApplicationController

group_name = "group_example"
  
  def index
    render json: {response: sync_group(group_name)}
    
  end
  

  
  private  
  
  # ------sync_group(group_name)------
  # description: main method. Synchronises discourse group with ldap group of the same name
  # takes group_name (String) of group as parameter
    
    def sync_group(group_name)
      
      users_array = get_members(group_name)
      group_id = get_group_id(group_name)
      users_array.each do |user|
        add_user_group(group_id, user[0])
      end
     
      "users added!"
    end

  # ------get_members(group_name)------
  # description: gets a group's members from ldap
  # takes group_name (String) as parameter
  # returns group_members (String hash)
  
    def get_members(group_name)
      ldap = Net::LDAP.new :host => SiteSetting.ldap_hostname,
     :port => SiteSetting.ldap_port,
     :auth => {
           :method => :simple,
           :username => SiteSetting.ldap_bind_dn,
           :password => SiteSetting.ldap_password
     }

      #might need to change the ldap filter string to use the group's dn (from ldap), in some cases, instead of group_name for it to work
      filter = Net::LDAP::Filter.construct("memberOf=CN="+group_name)
      
      treebase = SiteSetting.ldap_base

      result_attrs = ["mail"]
      
      group_members = []
      ldap.search(:base => treebase, :filter =>
      filter, :attributes => result_attrs,:return_result =>
      false) do |entry|
        group_members.append(entry["mail"])
      end
      group_members
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
  # takes user's email (String) as parameter
  # returns a user (User)
  
    def get_user_discourse(user_email)
      user = User.find_by_email(user_email)
      user
    end
    
  # ------add_user_group(group_id, user_email)------
  # description: adds a user to the discourse group
  # takes discourse group_id (String) and user email (String) as parameters
  # doesn't return anything
  
    def add_user_group(group_id, user_email)
      group = Group.find(group_id)
      if group
        user = get_user_discourse(user_email)
        if user
          #if user isn't already in group, add user
          if !GroupUser.find_by(group_id: group.id, user_id: user.id)
            group.add(user)
          end
        end
      end
    end
    
    
end

