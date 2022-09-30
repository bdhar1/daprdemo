
az aks get-credentials -n aks-dapr-demo -g dev-vdi-vm005-sandbox-rg

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

az k8s-extension create --cluster-type managedClusters --cluster-name aks-dapr-demo --resource-group dev-vdi-vm005-sandbox-rg --name myDaprExtension --extension-type Microsoft.Dapr --auto-upgrade-minor-version true

# Add KEDA AKS features to CLI
az extension add --upgrade --name aks-preview

# KEDA features
az feature register --namespace Microsoft.ContainerService --name AKS-KedaPreview

# for checking
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-KedaPreview')].{Name:name,State:properties.state}"

# Refreshing registration
az provider register --namespace Microsoft.ContainerService

# Enable in AKS Cluster
az aks update --resource-group dev-vdi-vm005-sandbox-rg --name aks-dapr-demo --enable-keda

# Check for KEDA enabled state
az aks show -g "dev-vdi-vm005-sandbox-rg" -n "aks-dapr-demo" --query "workloadAutoScalerProfile.keda.enabled" 

# Local DAPR simulation -- Service 2
dapr run --app-port 8080 --app-id ServiceApp2 --app-protocol http --dapr-http-port 3500 -- python main.py

# Service 1
dapr run --app-port 8081 --app-id ServiceApp1 --app-protocol http --dapr-http-port 3501 --components-path ../../components -- python main.py
dapr run --app-port 8085 --app-id ServiceApp3 --app-protocol http --dapr-http-port 3502 --components-path ../../cosmosdbcomponents -- python main.py

curl -X POST -H "dapr-app-id: ServiceApp1" -H "content-type: application/json" http://localhost:3501/
curl -X POST -H "dapr-app-id: ServiceApp3" -H "content-type: application/json" http://localhost:3502/

# Jumpbox ssh
ssh aaeran@jumpbox2.centralus.cloudapp.azure.com

#pubsub
dapr run --app-id service1 --components-path ../../components -- python app.py

#dapr run --app-id service3 --components-path ../../components --app-port 6001 -- uvicorn app:app --port 6002
#dapr run --app-id service4 --components-path ../../components --app-port 6003 -- uvicorn app:app --port 6004
dapr run --app-id service3 --components-path ../../components --app-port 6001 -- python app.py
dapr run --app-id service4 --components-path ../../components --app-port 6003 -- python app.py
dapr run --app-id service2 --components-path ../../components --app-port 6005 -- python app.py




 kubectl apply -f namespace.yaml
 kubectl apply -f cosmosdb.yaml
 kubectl apply -f pgStateStore.yaml
 kubectl apply -f pubsub.yaml

 az acr build --registry acrdaprdemo1001aa --image   service1:0.1 --file ./Dockerfile .
 kubectl apply -f sidecar.yaml
 az acr build --registry acrdaprdemo1001aa --image   service2:0.1  --file ./Dockerfile .
 kubectl apply -f sidecar.yaml
 az acr build --registry acrdaprdemo1001aa --image   service3:0.2 --file ./Dockerfile .
 kubectl apply -f sidecar.yaml
 az acr build --registry acrdaprdemo1001aa --image   service4:0.1  --file ./Dockerfile .
 kubectl apply -f sidecar.yaml