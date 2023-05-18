#--------------------------------------------------------------
# Basically, it is already set so that the setting is completed only by changing tfvars.
# All parameters that need to be changed for each environment are described in TODO comments.
#--------------------------------------------------------------

#--------------------------------------------------------------
# Twingate
#--------------------------------------------------------------
twingate = {
  # TODO: Register the remote network you wish to manage in Twingate.
  remote_network = {
    name = "test"
  }
  # TODO: Register the connnector you wish to manage in Twingate.
  connector = {
    name = "aws"
  }
  # TODO: Register the groups you wish to manage in Twingate.
  group = {
    name = "testgroup"
  }
  user = {
    # TODO: Register a person to login to Twingate.
    testuser = {
      first_name = "user"
      last_name  = "test"
      email      = "test@test.com"
      role       = "MEMBER"
    }
  }
  # TODO: Register the resources (DNS or CIDR) you need to access with Twingate.
  resource = {
    test = {
      name    = "test"
      address = "www.test.com"
      alias = null
      protocols = {
        allow_icmp = true
        tcp = {
          policy = "ALLOW_ALL"
        }
        udp = {
          policy = "ALLOW_ALL"
        }
      }
    }
  }
}
