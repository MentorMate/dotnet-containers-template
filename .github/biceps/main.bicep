targetScope = 'subscription'

param app_name string = 'calc-template'
param storage_name string = 'calctemplatestorage'
param apiImage string
param webImage string
param registry string
param registryUsername string
param location_name string = deployment().location

@secure()
param registryPassword string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: app_name
  location: location_name
}

module containerAppEnvironment 'environment.bicep' = {
  name: 'container-app-environment'
  scope: rg
  params: {
    app_name: app_name
    location_name: location_name
  }
}

module appDeployPlan 'infra.bicep' = {
  name: 'appDeploy'
  scope: rg
  params: {
    app_name: app_name
    storage_name: storage_name
    containerAppEnvironmentId: containerAppEnvironment.outputs.envId
    apiImage: apiImage
    webImage: webImage
    registry: registry
    registryUsername: registryUsername
    registryPassword: registryPassword
  }
}
