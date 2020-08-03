/**
 * Route for the path `/groups-sync` as defined in `../groups-sync-route-map.js.es6`.
 */
export default Discourse.Route.extend({
  renderTemplate() {
    // Renders the template `../templates/groups-sync.hbs`
    this.render('templates/groups-sync.hbs');
  }
});
