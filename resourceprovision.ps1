# these are all Azure resources that should be provisioned before..Can look to move this into a pipeline
# a number of these values are needed for the variable group

#set the prefix and location. For prefix probably best to use 4-5 lower case characters, and no dashes etc for safety
$prefix='ahms'
$location='westus'

# no need to change these. They will use the prefix. most of not all of these will need to be globally unique
$rgname='bcartifacts'
$storageaccname="$($prefix)bcstorage"
$containername='mktplace'
$acrname="$($prefix)bcacr"
$filesharename='bcshare'
$adminProfileKeyVaultName="$($prefix)bckvprofile"
$chaincodePackageIdStorageKeyVaultName="$($prefix)bckvchaincode"

az group create --name $rgname --location $location

az storage account create  --name $storageaccname `
    --resource-group $rgname `
    --location $location

az storage container create  --account-name $storageaccname  --name $containername 

$storagekey=az storage account keys list -g $rgname -n $storageaccname --query [0].value -o tsv
# need to double check.. might have to give azure devops sp correct permissions to storage account.. 

az storage share create --account-name $storageaccname --name $filesharename

az acr create -n $acrname  -g $rgname  --sku Basic
az acr update -n $acrname --admin-enabled true
$DOCKERUSERNAME=az acr credential show -n $acrname --query username -o tsv
$DOCKERPASSWORD=az acr credential show -n $acrname --query passwords[0].value -o tsv


az keyvault create --location $location --name $adminProfileKeyVaultName --resource-group $rgname
az keyvault create --location $location --name $chaincodePackageIdStorageKeyVaultName --resource-group $rgname
# would need to give service principal that Devops created appropriate permissions to create/read secrets. Code not included


Write-Output "Docker Username:$DOCKERUSERNAME"
Write-Output "Docker Password:$DOCKERPASSWORD"
Write-Output "storage account name:$storageaccname"
Write-Output "storage key:$storagekey"
Write-Output "ACR name:$acrname"
Write-Output "adminProfileKeyVaultName:$adminProfileKeyVaultName"
Write-Output "chaincodePackageIdStorageKeyVaultName:$chaincodePackageIdStorageKeyVaultName"
Write-Output "file sharename:$filesharename"
Write-Output "location:$location"








