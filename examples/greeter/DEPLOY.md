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

1. Extract Wildfly server under project root

    ```bash
    tar -xzvf ~/Downloads/wildfly-24.0.0.Final.tar.gz -C $PROJECT_ROOT
    ```

1. Create WAR and deploy on Application Server

    ```bash
    mvn clean install
    cp $PROJECT_ROOT/examples/greeter/target/greeter.war  $PROJECT_ROOT/wildfly-24.0.0.Final/standalone/deployments/greeter.war
    ```

1. Comfigure wildfly
    - Copy the `standalone-local.xml` config to wildfly configuration
    - Create mysql driver module directory
    - Copy mysql driver `module.xml`
    - Download and copy mysql driver jar into mysql driver module

    ```bash
    cp $PROJECT_ROOT/examples/greeter/deployment/wildfly/standalone/configuration/standalone-local.xml  $PROJECT_ROOT/wildfly-24.0.0.Final/standalone/configuration/standalone.xml
    mkdir -p $PROJECT_ROOT/wildfly-24.0.0.Final/modules/system/layers/base/com/mysql/driver8/main
    cp $PROJECT_ROOT/examples/greeter/deployment/wildfly/modules/system/layers/base/com/mysql/driver8/main/module.xml $PROJECT_ROOT/wildfly-24.0.0.Final/modules/system/layers/base/com/mysql/driver8/main
    curl -L  https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.25/mysql-connector-java-8.0.25.jar -o $PROJECT_ROOT/wildfly-24.0.0.Final/modules/system/layers/base/com/mysql/driver8/main/mysql-connector-java-8.0.25.jar
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

1. (Optional) Create Container image and push to registry. 

    ```bash
    docker build -t ghcr.io/yogendra/javaee-greeter:latest -f Dockerfile .
    docker push ghcr.io/yogendra/javaee-greeter:latest
    ```

    You can use existig image from  my public registry. You will need to [create registry specific credential secret and patch your service account](#create-registry-credentials).

1. Deploy application on  Tanzu

    ```bash  
    kubectl apply -f $PROJECT_ROOT/examples/greeter/deployment/tanzu/01_ns-psp.yaml
    kubectl apply -f $PROJECT_ROOT/examples/greeter/deployment/tanzu/05_app-secret.yaml
    kubectl apply -f $PROJECT_ROOT/examples/greeter/deployment/tanzu/06_app-deployment.yaml
    kubectl apply -f $PROJECT_ROOT/examples/greeter/deployment/tanzu/07_app-service.yaml
    kubectl apply -f $PROJECT_ROOT/examples/greeter/deployment/tanzu/08_app-ingress.yaml
    ```

1. (Optional) Cleanup app deployment

    ```bash
    kubectl delete -f deployment/tanzu/05_app-secret.yaml
    kubectl delete -f deployment/tanzu/06_app-deployment.yaml
    kubectl delete -f deployment/tanzu/07_app-service.yaml
    kubectl delete -f deployment/tanzu/08_app-ingress.yaml
    ```

## Create Registry Credentials

1. Create a new registry secret. (Replace variables with proper values)

    ```bash
    kubectl create secret docker-registry <cred-name> \
            --docker-server=<docker-registry-address> \
            --docker-username=<docker-username> \
            --docker-password=<docker-password-or-access-token> \
            --docker-email=<email>
    ```

1. Patch service account to use registry secret

    ```bash
    # Crate image pull secret variable of format {"name": "secret-1-name"}, { "name": "secret-2-name"}...
    imagePullSecrets=$(kubectl get secrets --field-selector type=kubernetes.io/dockerconfigjson -o go-template='{{range $i, $e := .items}}{{ if gt $i 0}},{{end}}{"name": "{{$e.metadata.name}}"}{{end}}')

    # Prepare a patch string
    patch="{\"imagePullSecrets\": [ $imagePullSecrets ]}"

    # Apply patch
    kubectl patch serviceaccount default -p "$patch"
    ```

    Or if you use Fish Shell, use this:

    ```bash
    set imagePullSecrets (kubectl get secrets --field-selector type=kubernetes.io/dockerconfigjson -o go-template='{{range $i, $e := .items}}{{ if gt $i 0}},{{end}}{"name": "{{$e.metadata.name}}"}{{end}}')

    set patch "{\"imagePullSecrets\": [ $imagePullSecrets ]}"

    kubectl patch serviceaccount default -p "$patch"
    ```
