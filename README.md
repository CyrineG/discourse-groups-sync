A Discourse plugin that allows to sync discourse groups with ldap groups.

To enable it: 
  1) go to admin > plugins > "groups sync" > settings and enable the "groups sync" plugin.
  2) fill in the LDAP settings
  3) then, go to groups > your_group > manage > memberships > LDAP Synchronisation and fill in the input field with your LDAP group's DN. 
  
And that's it! 

Note: This plugin only adds already existing users in Discourse to the synced group.
