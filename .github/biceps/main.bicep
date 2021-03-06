// cspell:ignore mmtemplatedotnetgithub
targetScope = 'subscription'

param envName string = 'prod'
param app_name string = 'mm-devops-dotnet-github'
param storage_name string = 'mmtemplatedotnetgithub'
param apiImage string
param webImage string
param registry string
param containerRegistryUsername string
param location_name string = deployment().location

@secure()
param containerRegistryPassword string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: app_name
  location: location_name
}

module appDeployPlan 'apps.bicep' = {
  name: 'appDeploy'
  scope: rg
  params: {
    app_name: app_name
    envName: envName
    storage_name: storage_name
    apiImage: apiImage
    webImage: webImage
    registry: registry
    registryUsername: containerRegistryUsername
    registryPassword: containerRegistryPassword
  }
}

output fqdnWeb string = appDeployPlan.outputs.fqdnWeb
output fqdnApi string = appDeployPlan.outputs.fqdnApi
