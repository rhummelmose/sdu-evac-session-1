# sdu-evac

## Playbook 1

### Build container images

```console
foo@bar:~$ docker build -f Frontend/Dockerfile --no-cache -t sdu-evac-frontend ./Frontend
foo@bar:~$ docker build -f Backend/Dockerfile --no-cache -t sdu-evac-backend ./Backend
```

### Tag/push images

```console
foo@bar:~$ docker tag sdu-evac-frontend localhost:5001/sdu-evac-frontend:v0.1.0
foo@bar:~$ docker push localhost:5001/sdu-evac-frontend:v0.1.0
foo@bar:~$ docker tag sdu-evac-backend localhost:5001/sdu-evac-backend:v1.0.0
foo@bar:~$ docker push localhost:5001/sdu-evac-backend:v1.0.0
```

### Install mongodb / redis

```console
helm install mongodb bitnami/mongodb \
    --set image.repository=arm64v8/mongo \
    --set image.tag=latest \
    --set persistence.mountPath=/data/db
```

```console
helm install redis bitnami/redis \                 
    --set architecture=standalone \
    --set auth.enabled=false
```

### Apply manifests

```console
kubectl apply -f ./Session/manifests
```

## Playbook 2

### Terraform apply

```console
terraform -chdir=Session/terraform init
terraform -chdir=Session/terraform apply
```
