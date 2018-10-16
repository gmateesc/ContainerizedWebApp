# The secret web application with a bug


## Table of contents

- [Overview](#p0)

- [Building the Docker images](#p1)

- [The docker-compose configuration filea](#p2)

- [Getting the application to run](#p3)

- [The Go program to implement Fizz Buzz](#p4)

- [Fixing the panic in the application](#p5)




<a name="p0" id="p0"></a>
## Overview

I have gotten the web application without source code and I have writeen Go code that solves 
the Fizz Buzz problem.


The layout of the solution is shown in the figure below.


<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/project_layout.png" 
     alt="blob" width="400">



<a name="p1" id="p1"></a>
## Building the Docker images

I have built the Docker images for the web application and REDIS using docker-compose.

I have written two Dockerfiles:

* Alpine/Dockerfile - optimizes the image size by reducing the 
  number or RUN commands and using the --no-cache

* Alpine_small/Dockerfile - further optimizes the image size 
  not placing the application in the Docker image, but instead 
  downloading it on the Docker host and then mapping the 
  host directory to a container volume. This reduces  the 
  image size from 17.4 MB to 5.4 MB.




In other words, the small image is only 1 MB biger than the base image, as shown below:

<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/docker_image_size.png" 
     alt="blob" height="100"  width="580">




<a name="p2" id="p2"></a>
## The docker-compose configuration files


To build and run the normal and small Docker image for 
the web-application, use the files docker-compose.yml and 
docker-compose_small.yml, respectively. 

The configuration files docker-compose.yml and docker-compose_small.yml 
are sing different Dockerfiles to build the web-app

* docker-compose.yml uses Alpine/Dockerfile 

* docker-compose_small.yml used Alpine_small/Dockerfile 
  because thhe Docker image created in this case does 
  not contain the web-app, volume mapping is used 
  in docker-compose_small.yml to map a host directory 
  to a container directory


Both configuration files use the same Docker for Redis.


The tools start_app.sh and start_app_small.sh under libexec/ can 
be used to facilitate the building images and running the containers. 

Alternatively, the followinf commands can be used

```shell
   docker-compose up [-d]
```
and

```shell
   docker-compose -f docker-compose_small.yml up [-d]
```

where the -d option can ne used to start the containers in detached mode.




<a name="p3" id="p3"></a>
## Getting the application to run

To get the application running, I have used


* The environment variable PORT set in the Dockerfile to 8080, 
  because if the application runs as www, it cannot bind to 
  port 80;


* The environment variable REDIS_URL passed to the container 
  from the docker-composer.yml file


* Port mapping for the web-app container is specified in the 
  docker-compose file to map the host port 8080 to the 
  container port 8080, so that the web app can be accessed from the host


* Port mapping for the redis container is also specified in the 
  docker-compose file to make the REDIS port in container  
  accessible from the host and from the web-app container;


* Port mapping is specified in the docker-compose file to 
  map the host port 8080 to the container port 8080, so that 
  the web app can be accessed from the host






<a name="p3" id="p3"></a>
## Access the web application


I have used the endpoint 


```shell
http://localhost:8080/search?q=foo
```

and I received different responses, including

```
Magic 8-ball says: My reply is no
```

Some of the responses are shown in the screenshots below.



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_1.png" 
     alt="blob" width="400">



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_2.png" 
     alt="blob" width="400">



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_3.png" 
     alt="blob" width="400">






<a name="p4" id="p4"></a>
## The Go program to implement Fizz Buzz

The code in the web application does not implement Fizz Buzz correctly because when a 
number is divisible by both 3 and 5 the output must be FizzBuzz, but the code only 
checks that the number is divisible by 3 or 5, not by both.



I have written e Go program that produces the correct output, and uses a goroutine 
to generate the output and a channel to pass the generated output from the function 
FizzBuzz to the main function.




<a name="p5" id="p5"></a>
## Fixing the panic in the application


The web application is a Go application. The panic happens because the 
function converT2E  fails at some point, either because the arguments 
are wrong or because it cannot allocate the required memory.


The developer should check all the arguments passed to functions and 
the possible errors returned by the functions. Whan that makes sense, 
code to recover from the error should be inserted.


