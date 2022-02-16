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

    resource blobServiceWeb 'containers' = {
      name: '$app'
    }
  }
}

resource apiApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: '${app_name}-api'
  location: rg.location
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: false
        targetPort: 8080
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
          image: apiImage
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 3
      }
      dapr: {
        enabled: true
        appPort: 8080
        appId: 'api'
      }
    }
  }
}

resource webApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: '${app_name}-web'
  location: rg.location
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 8000
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
          image: webImage
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
      dapr: {
        enabled: true
        appPort: 8000
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
                secretRef: '${listKeys(storage.id, storage.apiVersion).keys[0].value}'
              }
              {
                name: 'containerName'
                value: '${storage_name}/default/$app'
              }
            ]
          }
        ]
      }
    }
  }
}

output fqdn string = webApp.properties.configuration.ingress.fqdn
