param location string
param appName string
param skuTier string
param skuSize string

resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${appName}'
  location: location
  sku: {
    name: skuSize
    tier: skuTier
  }
}

resource app 'Microsoft.Web/sites@2023-01-01' = {
  name: 'app-${appName}'
  location: location
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
  }
}

output defaultHostName string = app.properties.defaultHostName
output appName string = app.name
