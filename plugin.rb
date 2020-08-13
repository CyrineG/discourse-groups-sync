# name: groups sync
# about: A Discourse plugin that allows to sync discourse groups with ldap groups.
# version: 0.1.1
# authors : Cyrine Gamoudi <cyrinegamoudi@ieee.org> 


enabled_site_setting :groups_sync_enabled


gem 'net-ldap', '0.16.2'


after_initialize do
  load File.expand_path('../app/controllers/groups_sync_controller.rb', __FILE__)
  
  require_relative 'app/jobs/scheduled/groups_sync_job'

  Discourse::Application.routes.append do
    # Map the path `/groups-sync` to `GroupsSyncController`’s `index` method
    get '/groups-sync' => 'groups_sync#index'
  end
  
 #creating a custom field group_sync for groups
  Group.register_custom_field_type('group_sync', :boolean)
  Group.preload_custom_fields<< "group_sync" if Group.respond_to? :preloaded_custom_fields
  
=begin  

#to enable custom field group_sync for group "example"
  group = Group.find_by(name:"example")
  group.custom_fields["group_sync"] = true
  group.save

#to disable custom field group_sync for group "example"
  group2 = Group.find_by(name:"example")
  group2.custom_fields["group_sync"] = false
  group2.save
=end   

  
  
  
end





