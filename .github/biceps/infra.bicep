param app_name string
param sku_storage_name string = 'Standard_LRS'
param storage_name string
param apiImage string
param webImage string
param containerAppEnvironmentId string

param registry string
param registryUsername string
@secure()
param registryPassword string

var rg = resourceGroup()

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storage_name
  location: rg.location
  sku: {
    name: sku_storage_name
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
  
  resource blobService 'blobServices' = {
    name: 'default'

    resource blobServiceContainerState 'containers' = {
      name: 'state'
    }
  }
}

resource apiApp 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: '${app_name}-api'
  location: rg.location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      secrets: [
        {
          name: 'container-registry-password'
          value: registryPassword
        }
      ]
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'calc-api'
          image: apiImage
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 3
        rules: [
          {
            name: 'cpu-scaling'
            custom: {
              type: 'cpu'
              metadata: {
                type: 'Utilization'
                value: '85'
              }
            }
          }
          {
            name: 'memory-scaling'
            custom: {
              type: 'memory'
              metadata: {
                type: 'Utilization'
                value: '85'
              }
            }
          }
        ]
      }
      dapr: {
        enabled: true
        appPort: 80
        appId: 'api'
      }
    }
  }
}

resource webApp 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: '${app_name}-web'
  location: rg.location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      secrets: [
        {
          name: 'container-registry-password'
          value: registryPassword
        }
        {
          name: 'storage-key'
          value: '${listKeys(storage.id, storage.apiVersion).keys[0].value}'
        }
      ]
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'calc-web'
          image: webImage
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
      dapr: {
        enabled: true
        appPort: 80
        appId: 'web'
        components: [
          {
            name: 'statestore'
            type: 'state.azure.blobstorage'
            version: 'v1'
            metadata: [
              {
                name: 'accountName'
                value: storage.name
              }
              {
                name: 'accountKey'
                secretRef: 'storage-key'
              }
              {
                name: 'containerName'
                value: 'state'
              }
            ]
          }
        ]
      }
    }
  }
}

output fqdnWeb string = webApp.properties.configuration.ingress.fqdn
output fqdnApi string = apiApp.properties.configuration.ingress.fqdn
