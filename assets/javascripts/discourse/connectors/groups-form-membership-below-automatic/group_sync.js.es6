import { ajax } from "discourse/lib/ajax";


export default {

  
  setupComponent(args, component) {
    active_status: true;
    ldapDN:"";
    },
  
  actions:{

    
    
    commit(group, status, ldapDN){
      
      ajax(`/groups/${group.id}.json`, { type: "PUT",
        data: {
          group: {
            custom_fields: {
              group_sync: status,
              ldap_dn: ldapDN
            }
          }
        } 
      });
    },
    
    saveLDAPdn(){
      let group= this.model;
      if (Ember.isEmpty(this.ldapDN) || this.ldapDN === " ") {
        this.commit(group,false, this.ldapDN);
      } else {
        this.commit(group,true, this.ldapDN);
      }
  },
  
  onChangeLDAPdn(value){
      this.ldapDN = value;
      this.saveLDAPdn();
    }
}

}


