param app_name string
param location_name string

resource law 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: app_name
  location: location_name
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource env 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: app_name
  location: location_name
  kind: 'containerenvironment'
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}

output clientId string = law.properties.customerId
output envId string = env.id
