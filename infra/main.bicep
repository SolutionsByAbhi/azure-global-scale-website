param location string = 'westeurope'
param env string = 'prod'
param appName string = 'globalweb'
param skuTier string = 'Standard'
param skuSize string = 'S1'

@description('Global resource group name')
param resourceGroupName string = 'rg-${appName}-${env}'

module rg './modules/resourceGroup.bicep' = {
  name: 'rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module appPlanAndApp './modules/appServicePlanAndApp.bicep' = {
  name: 'appService'
  scope: resourceGroup(rg.outputs.name)
  params: {
    location: location
    appName: appName
    skuTier: skuTier
    skuSize: skuSize
  }
}

module postgres './modules/postgres.bicep' = {
  name: 'postgres'
  scope: resourceGroup(rg.outputs.name)
  params: {
    location: location
    appName: appName
    env: env
  }
}

module redis './modules/redisCache.bicep' = {
  name: 'redis'
  scope: resourceGroup(rg.outputs.name)
  params: {
    location: location
    appName: appName
    env: env
  }
}

module appGw './modules/appGatewayWaf.bicep' = {
  name: 'appGateway'
  scope: resourceGroup(rg.outputs.name)
  params: {
    location: location
    appName: appName
    env: env
    appServiceHostName: appPlanAndApp.outputs.defaultHostName
  }
}

module frontDoor './modules/frontDoorCdn.bicep' = {
  name: 'frontDoor'
  scope: resourceGroup(rg.outputs.name)
  params: {
    appName: appName
    env: env
    originHostName: appGw.outputs.publicIpFqdn
  }
}

module monitor './modules/monitor.bicep' = {
  name: 'monitor'
  scope: resourceGroup(rg.outputs.name)
  params: {
    location: location
    appName: appName
    env: env
  }
}

output globalEndpoint string = frontDoor.outputs.endpointHostName
