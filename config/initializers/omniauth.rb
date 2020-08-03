Rails.application.config.middleware.use OmniAuth::Builder do
  provider :LDAP, "LDAP-Login #{ldap.forumsys.com}", { :host =>
  "ldap.forumsys.com", :port => "389", :method => :plain, :base => "cn=read
  only-admin,dc=example,dc=com", :uid =>'riemann', :bind_dn =>
  "cn=read-only-admin,dc=example,dc=com" }
end

