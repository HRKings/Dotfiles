def "az sqlupdatefirewallip" [
  pubip: string
  resource_group: string
  server: string
  rule_name: string
] {
  let rule = (^az sql server firewall-rule list --resource-group $resource_group --server $server | from json | where name == $rule_name)

  if ( $pubip == $rule.startIpAddress ) {
    print $"The current IP (($pubip)) is the same as the registered in the rule."
    print "The rule is described bellow:"
    return $rule
  }

  ^az sql server firewall-rule update -g $resource_group -s $server -n $rule_name --start-ip-address $pubip --end-ip-address $pubip | from json
}

def "az account select" [

] {
  let accounts = ( ^az account list | from json )

  let chosen_account = ( $accounts | get name | sk )

  ^az account set --subscription $chosen_account
}
