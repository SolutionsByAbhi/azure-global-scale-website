param location string
param appName string
param env string

var serverName = 'pg-${appName}-${env}'
var dbName = 'globalwebdb'

resource pg 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '14'
    availabilityZone: '1'
    highAvailability: {
      mode: 'ZoneRedundant'
    }
    storage: {
      storageSizeGB: 64
    }
  }
}

resource db 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: '${pg.name}/${dbName}'
  properties: {}
}

output connectionStringTemplate string = 'Host=${pg.name}.postgres.database.azure.com;Database=${dbName};User Id=<user>@${pg.name};Password=<password>;Ssl Mode=Require;'
