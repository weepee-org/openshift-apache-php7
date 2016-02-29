# openshift-apache-php7

Template for running a apache php7 on a container based on alpine linux/openshift/docker.

### Installation

You need oc (https://github.com/openshift/origin/releases) locally installed:

create a new project (change to your whishes) or add this to your existing project

```sh
oc new-project openshift-apache-php7 \
    --description="WebServer - Apache PHP7" \
    --display-name="Apache PHP7"
```

Deploy (externally)

```sh
oc new-app https://github.com/weepee-org/openshift-apache-php7.git --name apache-php7
```

Deploy (weepee internally)
add to Your buildconfig
```yaml
spec:
  strategy:
    dockerStrategy:
      from:
        kind: ImageStreamTag
        name: php7-webserver:latest
        namespace: weepee-registry
    type: Docker
```
use in your Dockerfile
```sh
FROM weepee-registry/php7-webserver

# Your app
ADD app /app
```

#### Route.yml

Create route for development and testing

```sh
curl https://raw.githubusercontent.com/ure/openshift-apache-php/master/Route.yaml | oc create -f -
```
