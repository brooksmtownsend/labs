+++
title = "Deploying a Stateless Go App"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = false
pre = "<i class='fas fa-flask'></i> "
+++

## Deploying a Stateless Golang App in Critical Stack

### Getting Started

Pre-requisites:

1. [Go](https://golang.org/dl/)
1. [Visual Studio Code](https://code.visualstudio.com/download)
1. `curl` or some equivalent way to do _**GET**_ and _**POST**_
1. If using `curl`, `python` to make _**JSON**_ prettier
1. Docker : [Docker](https://www.docker.com/get-started)
1. Public container registry [Docker Hub](https://hub.docker.com) 
1. A _**Critical Stack**_ deployment with a user account provisioned for you.  Note your _**namespace**_ when you login.

## Overview

In this lab, you will deploy a simple _**Go**_ `Hello World` application in _**Critical Stack**_ and create _**Services**_ to make it available externally.  We will then illustrate how upgrade the deployment by creating a new release of the application.

Lifted from [Making a RESTful JSON API in Go](https://thenewstack.io/make-a-restful-json-api-go/) and adapted to Critical Stack, this is just example code and not intended to teach proper Go coding in any form.

## Building your Hello World App

1. Create a working directory to build your `Hello World` application.  Open a terminal window.  In your current working directory (we will use the `Development` directory under the user's home directory in this example), create a lab directory called `go` and a subdirectory of that call 'app'

	```console
	cd ~/Development
	mkdir -p go/app
	cd go/app
	```
2.  Using the editor of your choice, create a new file called `main.go` inside the **app** directory.

	```console
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
1. Compile an executable (in this example a GO executable) which properly targets a linux OS and is built statically with bare-minimum libs and dependencies. In this example we have decided to name the executable `hello-go`.
	
	```console
	$ CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -a -o hello-go .
	```
	
1.  A new file called `hello-go` will be created in the same directory.  This  will be referenced when we build our docker container.

1.  Create a new file in the same directory and name it `Dockerfile`.  This file could be named anything but for now we will just keep it simple.  Copy the following code into this file:

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

1. Login to Docker registry
	
	`docker login`

	```console
	$ docker login
	Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
	Username: jabbottc1
	Password:
	Login Succeeded
	```

1.  Build a Docker image using the `Dockerfile`.  Make sure to include the `.` at the end of the following command.  **hello-go** is the name of the image we are creating.

	`docker build -t hello-go -f Dockerfile .`

## Testing your Hello World App
1.  **Optional Step**. If you want to test your new docker container locally and see if it behaves as expected you can run the following command:

	`docker run -e PORT=8080 -p 8080:8080 --rm -ti hello-go`

1. Verify the app works by using the following command in a **new terminal window**.  Alternatively, you could open a browser to `http://localhost:8080`

	`curl http://localhost:8080`

	**Note**: to stop the running container run this command from the new terminal window (this uses `--filter` (`-f`) to find the container created from your `hello-go` image):

	`docker stop $(docker ps -qf "ancestor=hello-go")`

	Another way to stop the `hello-go`container is to view all of the running docker containers and issue a command to stop it by the id

	```console
   $ docker container ls
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              	PORTS                    NAMES
	6009be3dfae3        hello-go            "/hello-go"         5 seconds ago       Up 4 seconds        	0.0.0.0:8080->8080/tcp   goofy_swanson
	```
	```console
	$ docker stop 6009be3dfae3 
	6009be3dfae3
	$ docker container ls
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              	PORTS               NAMES
	```

## Tagging and pushing your image to a container registry    

1. Now that we have an image we need to apply a `tag` and `push` it to a container registry.

1. Docker Tags allow you to convey useful information about a specific image version/variant.  Rather than referring to your image by the `IMAGE ID` you can create an alias to your images.  Lets look at the list of images locally (your list might be different):

	`docker images`
	
	```console
	$ docker images
	REPOSITORY             TAG                 IMAGE ID            CREATED             
	hello-go               latest              56f2fefe6685        2 hours ago
	alpine                 latest              8cb3aa00f899        3 weeks ago         
	tomcat                 8.0                 ef6a7c98d192        6 months ago
	```
1.  We will `tag` your local image with your **namespace/repo**

	`docker tag hello-go <your-registry-user-name>/hello-go:0.0.1`
	
	```console
	$ docker tag hello-go jabbottc1/hello-go:0.0.1
	```
	
	**Optional Step** list your images and tags

	`docker images`
	
	```console
	$ docker images
	REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
	jabbottc1/hello-go       0.0.1               511503f3b991        16 minutes ago      7.06MB
	hello-go                 latest              511503f3b991        16 minutes ago      7.06MB
	```


1. Push the tagged image into your public container registry

	`docker push jabbottc1/hello-go:0.0.1`
	
	```console
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
	Your image digest and layer hashes will differ.

## Deploy your container into Critical Stack

1. Follow [deployment steps similar to Node lab](../../node/deploystateless) with appropriate substitutions.

1.  Navigate to your application host to see your **Hello World** message or run `curl` to verify that you application is running and exposed externally.  **Note** it may take a few minutes for this new cname to be created.

	`curl -s http://<URL_for_your_deployment>`
	
	```console
	$ curl http://...
	Hello, "/"$ 
	```

### Conclusion
You have successfully deployed a golang application in Critical Stack.  But _**Hello World**_ isn't enough, right?  Next we will deploy a [golang application with a REST API](../hello+REST).


### TODO
Show how to build with scripts 
1. sh build.sh -v 0.0.1

