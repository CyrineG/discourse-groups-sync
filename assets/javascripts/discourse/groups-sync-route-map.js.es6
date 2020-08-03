/**
 * Links the path `/groups-sync` to a route named `groups-sync`. Named like this, a
 * route with the same name needs to be created in the `routes` directory.
 */
export default function () {
  this.route('groups-sync', { path: '/groups_sync' });
}
