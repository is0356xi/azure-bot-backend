prefix="azurebot"

if [ -z "$1" ]; then
    echo "Please input image version (i.e. v1.0.0)"
    exit 1
fi

image_name="azure-bot-backend"
docker build -t $image_name ../

acr_name="${prefix}acr"
login_server="${acr_name}.azurecr.io"
version="$1"

az login
az acr login --name $acr_name
docker tag ${image_name} "$login_server/${image_name}:${version}"
docker push "$login_server/${image_name}:${version}"
echo "$login_server/${image_name}:${version}"

# Container Appsだけ更新する場合
# terraform apply --target azurerm_container_app.capp