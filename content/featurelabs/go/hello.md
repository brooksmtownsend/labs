+++
title = "Deploying a Go App"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = false
pre = "<i class='fas fa-flask'></i> "
+++

## Deploying a Stateless Golang App in Critical Stack

### Getting Started

Before starting this lab, you will need:

1. [Go](https://golang.org/dl/) installed
1. [Visual Studio Code](https://code.visualstudio.com/download) (or your favorite IDE)
1. `curl` or some equivalent way to do _**GET**_ and _**POST**_  &nbsp; (The _**Postman**_ browser plugin is a good alternative).
1. If using `curl`, `python` to make _**JSON**_ prettier (you can also use `jq`)
1. [Docker](https://www.docker.com/get-started) installed
1. Access to a public container registry, e.g. [Docker Hub](https://hub.docker.com) 
1. A _**Critical Stack**_ deployment with a user account provisioned for you.  Make sure to take note of your _**namespace**_ when you log in.

## Overview

In this lab, you will deploy a simple _**Go**_ "Hello World" application to _**Critical Stack**_ and create _**Services**_ to make it accessible externally.  We will then illustrate how upgrade the deployment by creating a new release of the application.

The Go code for this lab was lifted from [Making a RESTful JSON API in Go](https://thenewstack.io/make-a-restful-json-api-go/) and adapted to Critical Stack. This lab is not designed to illustrate Go programming practices or idioms.

## Building your Hello World App

We need something to deploy, so let's get started by creating the "Hello World" application.

Note: all source materials for this lab can be found in the [Critical Stack Feature Lab](https://github.com/criticalstack/labs-code.git) repository.

1. Create a working directory to build your "Hello World" application.  

	1. Open a terminal window.  
	1. In your current working directory (we will use the `Development` directory under the user's home directory in this example), create a lab directory called `go` and a subdirectory of that called 'app'

	```terminal
	cd ~/Development
	mkdir -p go/app
	cd go/app
	```
2.  Using the editor of your choice, create a new file called `main.go` inside the **app** directory.

	```terminal
	vi hello-go.go
	```
1.  Add the following content to your new file and **save**:

	```
	package main
 
	import (
          "fmt"
          "html"
          "log"
          "net/http"
	)
 
	func main() {
          http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
              fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
          })
 
          log.Fatal(http.ListenAndServe(":8080", nil))
	}
	```
1. Compile your Go executable so it properly targets a linux OS and is built statically with minimal dependencies. In this example we have decided to name the executable `hello-go`:
	
	```terminal
	$ CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -a -o hello-go .
	```
	
1.  A new executable binary called `hello-go` will be created in the same directory.  This will be referenced when we build our docker container.

1.  Create a new file in the same directory and name it `Dockerfile`.  This file could be named anything, but common convention is to use this filename.  Copy the following code into this file:

	```
	# STEP 1 build directory / file layout

	FROM ubuntu:latest as layout
	RUN groupadd -g 1000 appuser
	RUN useradd -r -u 1000 -g appuser appuser

	RUN mkdir -p /app/data && chmod -R 755 /app


	# STEP 2 debug if needed
	FROM busybox:latest as builder


	# STEP 3 build a small, non-root runtime image
	FROM scratch

	COPY --from=layout /etc/passwd /etc/passwd
	COPY --from=layout /etc/group /etc/group
	COPY --chown=appuser:appuser --from=layout /app/data /app/data

	# For debug
	COPY --from=builder /bin/busybox /bin/busybox
	COPY --from=builder /bin/sh /bin/sh

	WORKDIR /app
	USER appuser


	# STEP 4 add application
	ADD hello-go /app/hello-go

	EXPOSE 8080

	CMD ["/app/hello-go"]
	```

1. Login to your docker registry:
		
	```terminal
	$ docker login
	Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
	Username: jabbottc1
	Password:
	Login Succeeded
	```

1.  Build a Docker image using the `Dockerfile`.  Make sure to include the `.` at the end of the following command. The name of the image we're creating is **hello-go**:

	`docker build -t hello-go -f Dockerfile .`

## Testing Your Application
_Optional_ - if you want to test your docker image locally to see if it behaves as expected.

1.  Run the following command:

	`docker run -e PORT=8080 -p 8080:8080 --rm -ti hello-go`

1. Verify the app works by using the following command in a **new terminal window**.  Alternatively, you could open a browser to `http://localhost:8080`

	```terminal
	$ curl http://localhost:8080
	```
	
	**Note**: to stop the running container run this command from the new terminal window (this uses `--filter` (`-f`) to find the container created from your `hello-go` image):

	`docker stop $(docker ps -qf "ancestor=hello-go")`

	Another way to stop the `hello-go`container is to view all of the running docker containers and issue a command to stop it by the ID:

	```terminal
   $ docker container ls
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              	PORTS                    NAMES
	6009be3dfae3        hello-go            "/hello-go"         5 seconds ago       Up 4 seconds        	0.0.0.0:8080->8080/tcp   goofy_swanson
	```
	```terminal
	$ docker stop 6009be3dfae3 
	6009be3dfae3
	$ docker container ls
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              	PORTS               NAMES
	```

## Tagging and Pushing your Image to a Registry

Now that we have an image we need to apply a `tag` and `push` it to a container registry.

1. Docker tags allow you to convey useful information about a specific image version or variant.  Rather than referring to your image by the `IMAGE ID` you can create aliases for your images.  Lets look at the list of images locally (your list might be different):
		
	```terminal
	$ docker images
	REPOSITORY             TAG                 IMAGE ID            CREATED             
	hello-go               latest              56f2fefe6685        2 hours ago
	alpine                 latest              8cb3aa00f899        3 weeks ago         
	tomcat                 8.0                 ef6a7c98d192        6 months ago
	```
1.  We will `tag` your local image with your **namespace/repository** using the following command: `docker tag hello-go <your-registry-user-name>/hello-go:0.0.1`
	
	```terminal
	$ docker tag hello-go jabbottc1/hello-go:0.0.1
	```
	
	**Optional Step** list your images and tags	
	
	```terminal
	$ docker images
	REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
	jabbottc1/hello-go       0.0.1               511503f3b991        16 minutes ago      7.06MB
	hello-go                 latest              511503f3b991        16 minutes ago      7.06MB
	```


1. Push the tagged image into your public container registry	
	
	```terminal
	$ docker push jabbottc1/hello-go:0.0.1
	The push refers to repository [docker.io/jabbottc1/hello-go]
	1c82c58a49f6: Layer already exists
	d992cd40d944: Layer already exists
	e4ae77eef13a: Layer already exists
	8e3f00a45858: Layer already exists
	5483fef4153b: Layer already exists
	c1b4e3786f95: Layer already exists
	0.0.1: digest: sha256:385984109a3cf6b1a82dcebb1ee124a7172a5a81795bf8116f2cab6d7a09ca4e size: 1569
	```
	Your image digest and layer hashes will differ from the above terminal output.

## Deploy your container into Critical Stack
Deploying your container is as simple as following the [deployment steps in the Node lab](../../node/deploystateless/#deploying), but change the docker image name and other parameters as appropriate.

1. Navigate to your application host to see your **Hello World** message or run `curl` to verify that you application is running and exposed externally.  **Note** it may take a few minutes for this new **cname** to be created.

	`curl -s http://<URL_for_your_deployment>`
	
	```terminal
	$ curl http://...
	Hello, "/"$ 
	```

### Conclusion
You have now successfully deployed a Go application in Critical Stack.  But _**Hello World**_ isn't enough, right?  Next we will deploy a [Stateless RESTful Go App](../hello_rest).


### TODO
Show how to build with scripts 

1. sh build.sh -v 0.0.1

