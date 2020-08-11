# name: groups sync
# about: A Discourse plugin that allows to sync discourse groups with ldap groups.
# version: 0.1.1
# authors : Cyrine Gamoudi <cyrinegamoudi@ieee.org>


enabled_site_setting :groups_sync_enabled


gem 'net-ldap', '0.16.2'

after_initialize do
  load File.expand_path('../app/controllers/groups_sync_controller.rb', __FILE__)

  Discourse::Application.routes.append do
    # Map the path `/groups-sync` to `GroupsSyncController`’s `index` method
    get '/groups-sync' => 'groups_sync#index'
  end
end





