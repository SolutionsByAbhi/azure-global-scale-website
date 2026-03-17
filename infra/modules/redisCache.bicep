param location string
param appName string
param env string

resource redis 'Microsoft.Cache/Redis@2023-04-01' = {
  name: 'redis-${appName}-${env}'
  location: location
  sku: {
    name: 'Basic'
    family: 'C'
    capacity: 1
  }
  properties: {
    enableNonSslPort: false
  }
}

output redisHostName string = redis.properties.hostName
output redisPort int = redis.properties.sslPort
