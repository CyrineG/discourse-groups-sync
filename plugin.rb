# name: groups sync
# about: A Discourse plugin that allows to sync discourse groups with ldap groups.
# version: 0.1.1
# authors : Cyrine Gamoudi <syrynegamoudi@gmail.com> 


enabled_site_setting :groups_sync_enabled

gem 'net-ldap', '0.16.2'

after_initialize do

  require_relative 'app/jobs/scheduled/groups_sync_job'
  
 #creating the custom fields, group_sync and ldap_dn for groups
  Group.register_custom_field_type('group_sync', :boolean)
  Group.preload_custom_fields<< "group_sync" if
  Group.respond_to? :preloaded_custom_fields
  
  Group.register_custom_field_type('ldap_dn', :text)
  Group.preload_custom_fields<< "ldap_dn" if
  Group.respond_to? :preloaded_custom_fields
   
  register_editable_group_custom_field [:group_sync, :ldap_dn];

  if SiteSetting.groups_sync_enabled then  
    add_to_serializer(:group_show, :custom_fields, false) {
        object.custom_fields
    }
   end
  
end





