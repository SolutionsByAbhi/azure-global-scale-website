param appName string
param env string
param originHostName string

resource profile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: 'fd-${appName}-${env}'
  location: 'global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
}

resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2023-05-01' = {
  name: '${profile.name}/endpoint-${appName}-${env}'
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2023-05-01' = {
  name: '${profile.name}/og-${appName}-${env}'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2023-05-01' = {
  name: '${originGroup.name}/origin-agw'
  properties: {
    hostName: originHostName
    httpPort: 80
    httpsPort: 443
  }
}

output endpointHostName string = endpoint.properties.hostName
