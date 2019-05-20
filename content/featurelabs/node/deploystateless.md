+++
title = "Deploying a NodeJS App"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = false
pre = "<i class='fab fa-node'></i> "
+++

## Deploying a Stateless NodeJS App in Critical Stack

This lab will walk you through the process of deploying a stateless NodeJS application to Critical Stack.

### Getting Started
Before we get started, you'll need:

1. Node JS (and npm) installed : [Node.JS](https://nodejs.org/en/download/)
1. Docker installed : [Docker](https://www.docker.com/get-started)
1. Access to a public container registry (Docker Hub is easiest, Artifactory works too) : [Docker Hub](https://hub.docker.com)

### Overview
In this lab we will create a simple NodeJS application, deploy it via Critical Stack. and access it via a public URL.

### Steps

#### Building
1. Open a terminal window.  In your current working directory (in the example below we use the **Development** directory under the user's home directory) create a directory for this lab called **node-lab** and a subdirectory of that called **app**:
    ```terminal
    user@testhost Development$ mkdir -p node-lab/app
    user@testhost Development$ cd node-lab
    user@testhost node-lab$ ls
    app
    ```

1. Using the editor of your choice, create a file called **index.js** inside the **app** directory (resulting in **app/index.js**) with
the following content:
    ```
    // Say hello from Node
    var http = require('http');

    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello from Node!\n');
    }).listen(3000, "0.0.0.0");
    console.log('Server running on :3000');
    ```

1. Generate the app configuration with _npm_ in the root of your **node-lab** directory.
    
    Accept all defaults except _package name_, which should be something like **hello-node**, version number (this is definitely a `0.0.1` release!), and **entry point**, as that will be **app/index.js**
    ```terminal
    user@testhost node-lab$ npm init
    This utility will walk you through creating a package.json file.
    It only covers the most common items, and tries to guess sensible defaults.

    See `npm help json` for definitive documentation on these fields
    and exactly what they do.

    Use `npm install <pkg>` afterwards to install a package and
    save it as a dependency in the package.json file.

    Press ^C at any time to quite.
    package name: (user) hello-node
    version: (1.0.0) 0.0.1
    description:
    entry point: (index.js) app/index.js
    test command:
    git repository:
    keywords:
    author:
    license: (ISC)
    About to write to /Users/user/Development/node-lab/package.json:
    ```

1. `npm` makes it easy for JavaScript developers to share and re-use code.  Install the dependencies for this lab by running this command:
    
    ```terminal
    user@testhost node-lab$ npm install
    npm notice created a lockfile as package-lock.json. You should commit this file.
    npm WARN hello-node@0.0.1 No description
    npm WARN hello-node@0.0.1 No repository field.

    up to date in 10.179s
    found 0 vulnerabilities
    ```

1. Create a **Dockerfile** to target _node_ and copy the necessary files into the docker image (_Note to instructor_: explain the **base image** from which this image is derived). The port you choose to expose should be the same as the port on which your application server listens. Your _Dockerfile_ should be in the root of your **node-lab** directory and have the following content:
    ```
    FROM node:9

    # Make base directory
    RUN mkdir /src

    WORKDIR /src

    COPY ./package.json /src/package.json
    COPY ./package-lock.json /src/package-lock.json
    RUN npm install --silent

    COPY ./app /src/app

    EXPOSE 3000

    CMD ["node", "app/index.js"]
    ```

1. Build a Docker image using the _Dockerfile_ with the tag **hello-node**:
    
    ```terminal
    user@testhost node-lab$ docker build -t hello-node -f Dockerfile .
    Sending build context to Docker daemon  71.68kB
    Step 1/8 : FROM node:9
    ---> 08a8c8089ab1
    Step 2/8 : RUN mkdir /src
    ...
    ```

    If you want to test this out locally before deploying it, you can use docker to launch the process in the container image to verify that it behaves as expected:
    
    ```terminal
    user@testhost node-lab$ docker run -p 3000:3000 --rm -ti hello-node
    Server running on :3000
    ```
    Once this is running, you can check that the application works by using _curl_ in a new terminal window:
    
    ```terminal
    user@testhost ~$ curl http://localhost:3000/
    Hello from Node!
    ```

    Note: to stop the running container run this command from the new terminal window (this uses **-f** to find the container created from your **hello-node** image):

    ```terminal
    user@testhost ~$ docker stop $(docker ps -qf "ancestor=hello-node")
    42c18d268c56
    ```
    You should see the container exit and your shell prompt return in your original terminal window.

1. Login to your public container registry (in this example we use _**Docker Hub**_). Note your user name as you will use this later.
	
    ```terminal
    user@testhost node-lab$ docker login
    Login with your Docker ID to push and pull images from Docker Hub. If you don't
    have a Docker ID, head over to https://hub.docker.com to create one.
    Username: <your username here> 
    Password:
    Login Succeeded
    ```

1. Add the _**tag**_ to be used in the public container registry (Note to instructor: Advise on tag naming convention)
    
    ```terminal
    user@testhost node-lab$ docker tag hello-node <your-user-name>/hello-node:0.0.1
    ```

1. Push the tagged image into a public container registry
    
    ```terminal
    user@testhost node-lab$ docker tag hello-node <your-user-name>/hello-node:0.0.1
    The push refers to repository [docker.io/<your-user-name>/hello-node]
    99599c00434b: Pushed
    2c18bd33cb20: Pushed
    41b63aaeffc4: Pushed
    df64ff0ed93f: Pushed
    71521673e105: Mounted from library/node
    7695686f75c0: Mounted from library/node
    e492023cc4f9: Mounted from library/node
    cbda574aa37a: Mounted from library/node
    8451f9fe0016: Mounted from library/node
    858cd8541f7e: Mounted from library/node
    a42d312a03bb: Mounted from library/node
    dd1eb1fd7e08: Mounted from library/node
    0.0.1: digest: sha256:e755e97b58a700207b2a9ba0deaa26927210b84f8d79618d1c4cd8f498b97373 size: 2834
    ```
    Your image digest and layer hashes will differ.

#### Deploying
1. Login to Critical Stack.  Under _**Data Center > Workloads**_ select _**Deployments**_. Create a _**Simple**_ Deployment in Critical Stack. Call the app name whatever you like (in this example I used `my-first-deployment`). Next, point to the tagged Docker image recently pushed into the image registry (`docker.io/<your-user-name>/hello-node:0.0.1`). Leave the rest of the inputs at their defaults:

    ![Simple deployment](../../../images/featurelabs/node/simple_deployment.png "Simple deployment")

1. Under _**Data Center > Workloads**_ select _**Deployments**_ and confirm that the deployment created in the previous step is _**Available**_ (a non-zero number is visible in the _**Available**_ column).

    ![Available](../../../images/featurelabs/node/available.png "Available")

1. Under _**Data Center > Services and Discovery**_ select _**Services**_.  Create a _**Simple Service**_ in Critical Stack.

    1. Call the service name whatever you like (in this example I used `my-first-deployment-svc`).
    1. Match the _**Selector name**_ to the app/pod name which was deployed in the previous step.
    1. Select _**Load Balancer**_ as the option for _**Mode**_
    1. Call the _**listener name**_ whatever you like but something unique relative to the service name (in this example I used `my-first-deployment-listener`).
    1. Select _**TCP**_ as the protocol
    1. Under the _**Port**_ field, enter the desired port which will be used by the _**Load Balancer**_ connecting the app to the "live" public internet (typically port `80`).
    1. Under the _**Target Port**_ field, enter the port number supported by your app and exposed in your _**Dockerfile**_ (in this example, port `3000`)

    ![Create service](../../../images/featurelabs/node//create_service.png "Create service")

1. Under _**Data Center > Services and Discovery**_ select _**Services**_, check the service listing and note the dynamic port which was assigned to it.  In this example it is port _**32151**_ (but your port number will likely be different).

    ![Get dynamic port](../../../images/featurelabs/node/get_dynamic_port.png "Get dynamic port")

1. Under _**Data Center > Services and Discovery**_ select _**Endpoints**_, confirm that the service created has the just created listener configured to the port supported by the app and exposed in the _**Dockerfile**_ (in this example, port _**3000**_).

    ![Confirm Endpoint configuration](../../../images/featurelabs/node/confirm_endpoint_configuration.png "Confirm Endpoint configuration")

1. Log into the cloud provider console associated with this deployment of Critical Stack (note: we are running our Critical Stack cluster on AWS EC2. The following steps will be AWS-specific).

1. Navigate to the _**Load Balancers**_ section:

    ![Load Balancers section](../../../images/featurelabs/node/load_balancers_section.png "Load Balancers section")

1. Find the Load Balancer created by Critical Stack/Kubernetes during the creation of the Service in step 12. To quickly find the relevant load balancer, enter `kubernetes.io/service-name` as the _**Tag Key**_ in the Filter text box.

    For the _**Tag Value**_, enter in the name of the service created in the previous step. In this example, our service name is `critical-stack/my-first-deployment-svc`.

    ![Find Load Balancer](../../../images/featurelabs/node/find_load_balancer.png "FInd Load Balancer")

1. Click the Load Balancer found in the previous step. At the bottom of the screen you should see a tab called _**Description**_. Within the data displayed under that tab you should see _**DNS name**_ under the _**Basic**_ section. Copy this DNS value as it is the auto-generated, publicly facing domain name.

    ![Find public URL](../../../images/featurelabs/node/find_public_URL.png "Find public URL")

1. Paste the DNS value copied from the previous step into a browser. This confirms that the app we have deployed onto our Critical Stack cluster is fully live and available to the public internet.

    ![Go to public URL](../../../images/featurelabs/node/go_to_public_URL.png "Go to public URL")

### Conclusion
We created a simple NodeJS application, packaged the application in a Docker image, pushed the Docker image to a public Docker Hub repository, pulled that Docker image into a Critical Stack deployment as a container instance, and accessed the application via a public URL.

To learn the basics of managing the lifecycle of an application, see the [next lab](../updating).

