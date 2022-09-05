
az aks get-credentials -n aks-dapr-demo -g rg-dapr-demo

# Register features
az feature register --namespace "Microsoft.ContainerService" --name "AKS-ExtensionManager"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-Dapr"

# For checking
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-ExtensionManager')].{Name:name,State:properties.state}"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-Dapr')].{Name:name,State:properties.state}"

# Registering
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ContainerService

# Add extension to CLI
az extension add --name k8s-extension

az k8s-extension create --cluster-type managedClusters \
--cluster-name aks-dapr-demo \
--resource-group rg-dapr-demo \
--name myDaprExtension \
--extension-type Microsoft.Dapr \
--auto-upgrade-minor-version true

# Add KEDA AKS features to CLI
az extension add --upgrade --name aks-preview

# KEDA features
az feature register --namespace Microsoft.ContainerService --name AKS-KedaPreview

# for checking
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-KedaPreview')].{Name:name,State:properties.state}"

# Refreshing registration
az provider register --namespace Microsoft.ContainerService

# Enable in AKS Cluster
az aks update \
  --resource-group rg-dapr-demo \
  --name aks-dapr-demo \
  --enable-keda

# Check for KEDA enabled state
az aks show -g "rg-dapr-demo" -n "aks-dapr-demo" --query "workloadAutoScalerProfile.keda.enabled" 

# Local DAPR simulation -- Service 2
dapr run --app-port 8080 --app-id ServiceApp2 --app-protocol http --dapr-http-port 3500 -- python3 main.py

# Service 1
dapr run --app-port 8081 --app-id ServiceApp1 --app-protocol http --dapr-http-port 3501 --components-path ../../components -- python3 main.py