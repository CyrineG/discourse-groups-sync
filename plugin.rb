# name: groups sync
# version: 0.1.1

enabled_site_setting :groups_sync_enabled

after_initialize do
  load File.expand_path('../app/controllers/groups_sync_controller.rb', __FILE__)

  Discourse::Application.routes.append do
    # Map the path `/groups-sync` to `GroupsSyncController`’s `index` method
    get '/groups-sync' => 'groups_sync#index'
  end
end
