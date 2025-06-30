# cs-page-infra

Este repositório contém a infraestrutura Kubernetes para o site do curso de Bacharelado em Ciência da Computação do IFPR Campus Pinhais.

## Pré-requisitos

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://www.docker.com/)

## Clone os repositórios do projeto

1. **Crie uma nova pasta para o projeto:**
   ```sh
   mkdir cs-page
   cd cs-page
   ```

2. **Clone os repositórios necessários:**
   - Infraestrutura (este repositório):
     ```sh
     git clone https://github.com/EricoMeger/cs-page-infra
     ```
   - Frontend:
     ```sh
     git clone -b deploy https://github.com/VictorVechi/ReactComputerSciencePage
     ```
   - Backend/API:
     ```sh
     git clone -b deploy https://github.com/VictorVechi/ApiComputerSciencePage
     ```

## Instruções para rodar o projeto com Minikube

1. **Inicie o Minikube:**
   ```sh
   minikube start
   ```

2. **Configure o Docker para usar o ambiente do Minikube (opcional, mas recomendado para builds locais):**
   ```sh
   eval $(minikube docker-env)
   ```

3. **Faça o build local das imagens Docker do site:**
   ```sh
   docker build -t cs-frontend ReactComputerSciencePage/
   docker build -t cs-api ApiComputerSciencePage/
   ```

## Criação das Secrets necessárias

Antes de aplicar os manifests, crie dois arquivos de *Secret* na pasta `cs-page-infra/manifests`:

### 1. Secret do Backend (Chave do JWT)

Crie um arquivo chamado `backend-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secret
type: Opaque
stringData:
  SECRET_KEY: "sua_chave_jwt_aqui"
```

> **Obs:** A `SECRET_KEY` é a chave usada para assinar e validar tokens JWT no backend, não o token em si.

### 2. Secret do MongoDB

Crie um arquivo chamado `mongo-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
type: Opaque
stringData:
  MONGO_INITDB_ROOT_USERNAME: "seu_usuario"
  MONGO_INITDB_ROOT_PASSWORD: "sua_senha"
```

## Aplicando os manifests e acessando o sistema

1. **Aplique os manifests:**
   ```sh
   kubectl apply -f cs-page-infra/manifests/
   ```

2. **Verifique os pods e serviços:**
   ```sh
   kubectl get pods
   kubectl get svc
   ```

3. **Acesse o frontend:**
   - Ative o LoadBalancer local do Minikube rodando o tunnel:
     ```sh
     minikube tunnel
     ```
   - Em outro terminal, descubra o IP externo do serviço frontend:
     ```sh
     kubectl get svc frontend
     ```
   - No navegador, acesse o IP mostrado em `EXTERNAL-IP` na porta 80.
     ```sh
     <EXTERNAL-IP>:80
     ```

## Referências

- [Minikube - Instalação](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Definindo variáveis de ambiente em containers](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
- [Gerenciando Secret e ConfigMap](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-config-file/)
- [Deploy MongoDB e Mongo Express no Kubernetes com Secret e ConfigMap](https://medium.com/@m.ibtisam.syed/deploying-mongodb-and-mongo-express-on-kubernetes-using-minikube-including-secret-configmap-6cc994933ff2)
- [MongoDB Auth Connection](https://www.mongodb.com/community/forums/t/mongodb-connection-uri/248220)
- [Kubernetes PVC para MongoDB](https://stackoverflow.com/questions/70685863/kubernetes-and-mongo-pv-pvc)
- [Deploy Vite React App com Nginx](https://dev-mus.medium.com/how-to-deploy-a-vite-react-app-using-nginx-server-d7190a29d8cd)