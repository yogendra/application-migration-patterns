# Demo - Greeter

## Run Greeter on Local Machine

1. Go to greeter project

    ```bash
    cd $PROJECT_ROOT/examples/greeter
    ```

1. Run database

    ```bash
    docker-compose up -d  database
    ```

1. Create WAR and deploy on Application Server

    ```bash
    mvn clean install; cp target/greeter.war  $PROJECT_ROOT/wildfly-24.0.0.Final/standalone/deployments/greeter.war
    ```

1. Run greeter

    ```bash
    cd $PROJECT_ROOT/wildfly-24.0.0.Final
    bin/standalone.sh
    ```

## Run Greeter on Tanzu

1. Go to greeter project

    ```bash
    cd $PROJECT_ROOT/examples/greeter
    ```

1. Create Container image

    ```bash
    docker build -t ghcr.io/yogendra/javaee-greeter:latest -f Dockerfile .
    ```

1. Push image to registry

    ```bash
    docker push ghcr.io/yogendra/javaee-greeter:latest
    ```

1. Deploy application on  Tanzu

    ```bash  
    kubectl apply -f deployment/tanzu/05_app-secret.yaml
    kubectl apply -f deployment/tanzu/06_app-deployment.yaml
    kubectl apply -f deployment/tanzu/07_app-service.yaml
    kubectl apply -f deployment/tanzu/08_app-ingress.yaml
    ```

1. (Optional) Cleanup app deployment

    ```bash
    kubectl delete -f deployment/tanzu/05_app-secret.yaml
    kubectl delete -f deployment/tanzu/06_app-deployment.yaml
    kubectl delete -f deployment/tanzu/07_app-service.yaml
    kubectl delete -f deployment/tanzu/08_app-ingress.yaml
    ```
