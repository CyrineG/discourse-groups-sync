# frozen_string_literal: true

class Jobs::GroupsSyncJob < Jobs::Scheduled
  every 6.seconds
    
  def execute(args)

    #retrieving groups that have the group_sync custom field enabled

    groups_id_array= GroupCustomField.where(name: 'group_sync', value: "true").pluck(:group_id)
    
    groups_id_array.each do |group_id|
      sync_group(group_id)
    end

  end
  
  private  
  
  # ------sync_group(group_id)------
  # description: main method. Synchronises discourse group with an ldap group
  # takes group_id (Integer) of group as parameter
    
    def sync_group(group_id)
      group_ldap_dn = get_group_ldap_dn(group_id)
      users_array = get_members(group_ldap_dn)
      users_array.each do |user|
        add_user_group(group_id, user[0])
      end
    end
    
  # ------get_group_ldap_dn(group_id)------
  # description: gets a group's ldap dn
  # takes group_id (integer) as parameter
  # returns group_ldap_dn (String)    
    
    def get_group_ldap_dn(group_id)
      group = Group.find(group_id)
      group_ldap_dn = group.custom_fields['ldap_dn']
      group_ldap_dn
    end

  # ------get_members(group_ldap_dn)------
  # description: gets a group's members from ldap
  # takes group_ldap_dn (String) as parameter
  # returns group_members (String hash)
  
    def get_members(group_ldap_dn)
      ldap = Net::LDAP.new :host => SiteSetting.ldap_hostname,
     :port => SiteSetting.ldap_port,
     :auth => {
           :method => :simple,
           :username => SiteSetting.ldap_bind_dn,
           :password => SiteSetting.ldap_password
     }

      filter = Net::LDAP::Filter.construct('(memberOf='+ group_ldap_dn +')')
      
      treebase = SiteSetting.ldap_base

      result_attrs =["mail"]
      
      group_members = []
      ldap.search(:base => treebase, :filter =>
      filter, :attributes => result_attrs,:return_result =>
      false) do |entry|
        group_members.append(entry["mail"])
      end
      group_members
    end
   
  # ------get_user_discourse(user_email)------  
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

