param location string
param appName string
param env string
param appServiceHostName string

// Simplified: App Gateway + WAF in front of App Service
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'pip-agw-${appName}-${env}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'vnet-agw-${appName}-${env}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'agw-subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource appGw 'Microsoft.Network/applicationGateways@2023-04-01' = {
  name: 'agw-${appName}-${env}'
  location: location
  sku: {
    name: 'WAF_v2'
    tier: 'WAF_v2'
    capacity: 2
  }
  properties: {
    gatewayIPConfigurations: [
      {
        name: 'gwipconfig'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'frontendIpConfig'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'frontendPort'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: appServiceHostName
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'backendHttpSettings'
        properties: {
          port: 80
          protocol: 'Http'
          pickHostNameFromBackendAddress: true
        }
      }
    ]
    httpListeners: [
      {
        name: 'httpListener'
        properties: {
          frontendIPConfiguration: {
            id: appGw.properties.frontendIPConfigurations[0].id
          }
          frontendPort: {
            id: appGw.properties.frontendPorts[0].id
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'rule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: appGw.properties.httpListeners[0].id
          }
          backendAddressPool: {
            id: appGw.properties.backendAddressPools[0].id
          }
          backendHttpSettings: {
            id: appGw.properties.backendHttpSettingsCollection[0].id
          }
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    }
  }
}

output publicIpFqdn string = publicIp.properties.dnsSettings.fqdn
