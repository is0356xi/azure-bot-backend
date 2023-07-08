# デプロイ方法

- 環境変数を設定する

```sh:terraform_src/terraform.tfvars
container_envs = {
  OPENAI_API_KEY               = "APIキー"
  OPENAI_API_BASE              = "エンドポイント"
  AZURE_OPENAI_DEPLOYMENT_NAME = "デプロイ名"
  AZURE_OPENAI_API_VERSION     = "2023-03-15-preview"
}
```

- Azureリソース作成

```sh:
cd terraform_src
terraform init
terraform apply
```

>Azure Container Registryにイメージをプッシュしていため、
Container Appsの作成でエラーになるが、以降のコマンドを実行する。


- Azure Container RegistryにDockerイメージをプッシュ
 
```sh:
sh upload_image.sh v1.0.0
```


- 再度、Container Appsの作成を実行

```sh:
terraform apply --target azurerm_container_app.capp
```