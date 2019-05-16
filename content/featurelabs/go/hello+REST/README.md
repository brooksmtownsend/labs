+++
title = "Deploying a Stateless Golang App with REST API"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = false
pre = "<i class='fas fa-flask'></i> "
+++

## Deploying a Stateless Golang App with REST API in Critical Stack

### Getting Started
Pre-requisites:

1. [Go](https://golang.org/dl/)
1. [Visual Studio Code](https://code.visualstudio.com/download)
1. `curl` or some equivalent way to do _**GET**_ and _**POST**_
1. If using `curl`, `python` to make _**JSON**_ prettier
1. Docker : [Docker](https://www.docker.com/get-started)
1. Public container registry [Docker Hub](https://hub.docker.com)
1. [Previous Go lab](../hello.md) for **Docker registry** and **Load Balancer** setup - this demo will just update the previous Docker image with new functionality

## Overview

Update [previous lab](../hello.md) to introduce a REST API.

Lifted from [Making a RESTful JSON API in Go](https://thenewstack.io/make-a-restful-json-api-go/) and adapted to Critical Stack.  This is just example code and not intended to teach proper Go coding in any form.

## Building Your RESTful Hello World App

1. Clone this repo if you haven't already and change directory to this lab so you can access the source code

1. As with previous lab, compile the REST API example code into `hello-go`.
	
	```console
	$ CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -a -o hello-go .
	```

1.  As with previous lab, build a Docker image using the `Dockerfile`.

	
	`docker build -t hello-go -f Dockerfile .`
	
	

## Testing your RESTful Hello World App
1.  **Optional Step**. If you want to test your new docker container locally and see if it behaves as expected you can run the following command:

	
	`docker run -e PORT=8080 -p 8080:8080 --rm -ti hello-go`
	
1. Verify the app works by using the following command in a **new terminal window**.  Alternatively, you could open a browser to `http://localhost:8080`

	Basic test:
	`curl -s http://localhost:8080`
	
	```console
	$ curl -s http://localhost:8080
	Welcome!
	```
	
1. Show entries pre-inserted:
	`curl -s http://localhost:8080/todos | python -m json.tool`
	
	```console
	$ curl -s http://localhost:8080/todos | python -m json.tool
	[
     	{
     		"completed": false,
        	"due": "0001-01-01T00:00:00Z",
        	"id": 1,
        	"name": "Write presentation"
    	},
    	{
        	"completed": false,
        	"due": "0001-01-01T00:00:00Z",
        	"id": 2,
        	"name": "Host meetup"
    	}
	]
	```
	
1. Show entry 1:
	`curl -s http://localhost:8080/todos/{1} | python -m json.tool`
	
	```console
	curl -s http://localhost:8080/todos/{1} | python -m json.tool
	{
    	"completed": false,
    	"due": "0001-01-01T00:00:00Z",
    	"id": 1,
    	"name": "Write presentation"
	}	
	```
	
1. Insert New entry:
	```console
	curl -s -H "Content-Type: application/json" -d '{"name":"New Todo"}' http://localhost:8080/todos`
	```
	
	```console
	$ curl -s -H "Content-Type: application/json" -d '{"name":"New Todo"}' http://localhost:8080/todos
	{"id":3,"name":"New Todo","completed":false,"due":"0001-01-01T00:00:00Z"}
	$ 
	```
	
1. Show entry 3:
	`curl -s http://localhost:8080/todos/{3} | python -m json.tool`
	
	```console
	$ curl -s http://localhost:8080/todos/{3} | python -m json.tool
	{
   		 "completed": false,
   	 	"due": "0001-01-01T00:00:00Z",
   	 	"id": 3,
   	 	"name": "New Todo"
	}
	```

	
	To stop the running container you can run
	
	```console
	docker stop $(docker ps -qf "ancestor=hello-go")
	```
	
## Tagging and pushing your image to a container registry
1. Tag the new image with tag `0.0.2` using your image/repo/tag

	`docker tag hello-go jabbottc1/hello-go:0.0.2`
	

1. Push to Docker registry

	`docker push jabbottc1/hello-go:0.0.2`
	
	```console
	$ docker push jabbottc1/hello-go:0.0.2
	The push refers to repository [docker.io/jabbottc1/hello-go]
	...
	```


1.  Edit your `hello-go-deployment` from the Critical Stack UI.  Update the image in the *Deployment* to pull `0.0.2`.  Then you can run the same tests as above but targeting the Load Balancer.

	```yaml
          image: 'jabbottc1/hello-go:0.0.2'  # Change this tag
    ```

1.  **Save** your deployment and **exit**

1.  Test your upgraded deployment.  Then you can run the same tests as above but targeting the Ingress host.
	```console
	$ curl -s -H "Content-Type: application/json" -d '{"name":"John Test"}' https://<URL_to_your_application>/todos
	```
	
	```console
	 $ curl -s https://<URL_to_your_application>/todos | python -m json.tool
	[
	    {
        "completed": false,
        "due": "0001-01-01T00:00:00Z",
        "id": 1,
        "name": "Write presentation"
        },
    	{
        "completed": false,
        "due": "0001-01-01T00:00:00Z",
        "id": 2,
        "name": "Host meetup"
    	},
    	{
        "completed": false,
        "due": "0001-01-01T00:00:00Z",
        "id": 3,
        "name": "John Test"
    	}
	]
	```
	
	



### Conclusion
You have successfully deployed a golang REST API application to Critical Stack.  But this application is flawed - it can't scale beyond 1 node and has no persistence.  So next we will deploy a [Go Application with a REST API and Persistence](../hello+REST+Persistence/).

Note:  some bugs with **DELETE**!


### TODO
Show how to build with scripts 

1. sh build.sh -v 0.0.2

