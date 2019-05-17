+++
title = "Deploying a Stateless RESTful Go App"
date = 2019-04-23T09:43:37-04:00
weight = 6
chapter = false
pre = "<i class='fas fa-flask'></i> "
+++

## Deploying a Stateless Golang App with REST API in Critical Stack

## Getting Started
Before starting this lab, you will need:

1. [Go](https://golang.org/dl/) installed
1. [Visual Studio Code](https://code.visualstudio.com/download) or your favorite IDE installed
1. `curl` or some equivalent way to do _**GET**_ and _**POST**_ &nbsp; (_**Postman**_ is a good alternative)
1. If using `curl`, `python` to make _**JSON**_ prettier (you can also use [jq](https://stedolan.github.io/jq/download/))
1. [Docker](https://www.docker.com/get-started) installed.
1. Access to a public container registry, e.g. [Docker Hub](https://hub.docker.com)
1. Completed the [Previous Go lab](../hello) for the **Docker registry** and **Load Balancer** setup - this demo will just update the previous Docker image with new functionality

## Overview

In this lab, we will be enhancing the work done in the previous lab to introduce a RESTful API and walking through the steps necessary to build and deploy this to Critical Stack.

The Go code was lifted from [Making a RESTful JSON API in Go](https://thenewstack.io/make-a-restful-json-api-go/) and adapted to Critical Stack. This is purely sample code and not intended to be used as a reference for best practices or idioms.

## Building Your RESTful Hello World App

1. Clone the accompanying [Critical Stack Feature Lab repo](https://github.com/criticalstack/labs-code.git) if you haven't already and change to the [hello_rest](https://github.com/criticalstack/labs-code/hello_rest/) directory so you can access the source code:

	`git clone https://github.com/criticalstack/labs-code.git`

	`cd labs-code/go/hello_rest`

1. As with previous lab, compile the REST API example code into `hello-go`.
	
	```terminal
	$ CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -a -o hello-go .
	```

1.  As with previous lab, build a Docker image using the `Dockerfile`.

	
	`docker build -t hello-go -f Dockerfile .`
	
	
## Testing your RESTful Hello World App
_**Optional Step**_: If you want to test your new docker container locally and see if it behaves as expected you can follow these steps:

1. Run the following command:

	`docker run -e PORT=8080 -p 8080:8080 --rm -ti hello-go`
	
1. Verify the app works by using the following command in a **new terminal window**.  Alternatively, you could open a browser to `http://localhost:8080`

	Basic test:
	`curl -s http://localhost:8080`
	
	```terminal
	$ curl -s http://localhost:8080
	Welcome!
	```
	
1. Show entries pre-inserted:
	`curl -s http://localhost:8080/todos | python -m json.tool`
	
	```terminal
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
	
1. Show entry 1: &nbsp; `curl -s http://localhost:8080/todos/1 | python -m json.tool`
	
	```terminal
	curl -s http://localhost:8080/todos/1 | python -m json.tool
	{
    	"completed": false,
    	"due": "0001-01-01T00:00:00Z",
    	"id": 1,
    	"name": "Write presentation"
	}	
	```
	
1. Insert a new entry:
		
	```terminal
	$ curl -s -H "Content-Type: application/json" -d '{"name":"New Todo"}' http://localhost:8080/todos
	{"id":3,"name":"New Todo","completed":false,"due":"0001-01-01T00:00:00Z"}	
	```
	
1. Show entry 3:	
	
	```terminal
	$ curl -s http://localhost:8080/todos/3 | python -m json.tool
	{
   		"completed": false,
   	 	"due": "0001-01-01T00:00:00Z",
   	 	"id": 3,
   	 	"name": "New Todo"
	}
	```

	
	To stop the running container you can execute: &nbsp;  `docker stop $(docker ps -qf "ancestor=hello-go")`	
	
## Tagging and Pushing to a Container Registry

1. Tag the new image with tag `0.0.2` using your image/repo/tag

	`docker tag hello-go jabbottc1/hello-go:0.0.2`
	

1. Push to a docker registry
		
	```terminal
	$ docker push jabbottc1/hello-go:0.0.2
	The push refers to repository [docker.io/jabbottc1/hello-go]
	...
	```


1.  Edit your `hello-go-deployment` from the Critical Stack UI.  Update the image in the _**Deployment**_ to pull `0.0.2`.  Then you can run the same tests as above but targeting the Load Balancer.

	```
          image: 'jabbottc1/hello-go:0.0.2'  # Change this tag
    ```

1.  **Save** your deployment and **exit**

1.  Test your upgraded deployment.  Then you can run the same tests as above but targeting the ingress host.
	```terminal
	$ curl -s -H "Content-Type: application/json" -d '{"name":"John Test"}' https://<URL_to_your_application>/todos
	```
	
	```terminal
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
	
	



## Conclusion
You have successfully deployed a RESTful Go application to Critical Stack.  But this application is flawed - it can't scale beyond 1 node and has no persistence!  So next we will deploy a Go Application with a REST API and Persistence.

Note:  some bugs with **DELETE**!


## TODO
Show how to build with scripts 

1. sh build.sh -v 0.0.2

