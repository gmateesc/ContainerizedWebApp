# The secret web application with a bug


## Table of contents

- [Overview](#p0)

- [Building the Docker images](#p1)
   - [Reducing the image size](#p11)

- [The docker-compose configuration files](#p2)

- [Getting the application to run](#p3)

- [Accessing the web application](#p4)

- [The Go program to implement Fizz Buzz](#p5)

- [Fixing the panic in the application](#p6)




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

* <a href="https://github.com/gmateesc/ContainerizedWebApp/blob/master/WebApplication/Alpine/Dockerfile">
  Alpine/Dockerfile</a> - optimizes the image size by reducing the 
  number or RUN commands and using the --no-cache


* <a href="https://github.com/gmateesc/ContainerizedWebApp/blob/master/WebApplication/Alpine/Dockerfile">
  Alpine_small/Dockerfile</a> - further optimizes the image size as described next.



<a name="p11" id="11"></a>
## Reducing the image size


The file Alpine_small/Dockerfile achieves minimization of the Docker image size 
by not placing the application in the Docker image, but instead 
downloading it on the Docker host and then mapping the host directory 
to a container volume. This reduces the image size from 17.4 MB to 5.4 MB.


In other words, the small image is only 1 MB biger than the base image, as shown below:

<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/docker_image_size.png" 
     alt="blob" height="100"  width="650">





<a name="p2" id="p2"></a>
## The docker-compose configuration files


To build and run the normal and small Docker image for 
the web-application, use the files docker-compose.yml and 
docker-compose_small.yml, respectively. 

The configuration files docker-compose.yml and docker-compose_small.yml 
are sing different Dockerfiles to build the web-app

* <a href="https://github.com/gmateesc/ContainerizedWebApp/blob/master/WebApplication/docker-compose.yml">
  docker-compose.yml</a> 
  uses Alpine_small/Dockerfile to build the Docker image for the web-applcation;

* <a href="https://github.com/gmateesc/ContainerizedWebApp/blob/master/WebApplication/docker-compose_small.yml">
  docker-compose_small.yml</a> 
  uses Alpine_small/Dockerfile to build the Docker image for the web-applcation;
  because thhe Docker image created in this case does  not contain the web-app 
  executable, volume mapping is used in docker-compose_small.yml to map a host directory 
  to a container directory



Both configuration files use the same Docker for Redis.


The tools start_app.sh and start_app_small.sh under libexec/ can 
be used to facilitate the building images and running the containers. 


Alternatively, the following commands can be used to bring up REDIS 
and the web application

```shell
   docker-compose up [-d]
```
and

```shell
   docker-compose -f docker-compose_small.yml up [-d]
```

where the -d option can ne used to start the containers in detached mode, 
in which case the console output from the Docker container is not sent to 
the terminal.




<a name="p3" id="p3"></a>
## Getting the application to run

To get the application running, I have used

* The environment variable PORT set in the Dockerfile to 8080, 
  because if the application runs as user "www", it cannot bind to 
  port 80;

* The environment variable REDIS_URL passed to the container 
  from the docker-compose files;

* Port mapping for the web-app container is specified in the 
  docker-compose file, in order to map the host port 8080 to the 
  container port 8080, so that the web app can be accessed from the host

* Port mapping for the redis container is also specified in the 
  docker-compose file, in order to make the REDIS port in container  
  accessible from the host and from the web-app container;

* Port mapping is specified in the docker-compose file to 
  map the host port 8080 to the container port 8080, so that 
  the web app can be accessed from the host.



A screenshot of starting REDIS and the web-app with the tool 
start_app.sh -- which invokes docker-compose -- is shown below:

<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/running_web_app.png" 
     alt="blob" width="720">

As mentioned above, the -d option to start_app.sh can be used to start the containers in detached mode. 




<a name="p4" id="p4"></a>
## Accessing the web application


I have used the endpoint, by analogy with Google search:


```shell
http://localhost:8080/search?q=foo
```

which I accessed with curl, as shown by this screenshot

<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/curl_out.png" 
     alt="blob" width="480">


as well as with the browser, with some of the responses being shown 
in the screenshots below.



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_1.png" 
     alt="blob" width="400">



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_2.png" 
     alt="blob" width="400">



<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/webapp_3.png" 
     alt="blob" width="400">






<a name="p5" id="p5"></a>
## The Go program to implement Fizz Buzz

The code in the web application does not implement Fizz Buzz correctly because when a 
number is divisible by both 3 and 5 the output must be FizzBuzz, but the code only 
checks that the number is divisible by 3 or 5, not by both.


I have written e Go program that produces the correct output, and uses a goroutine 
to generate the output and a channel to pass the generated output from the function 
FizzBuzz to the main function.

The Go program fizz_buzz.go can be browsed 
<a href="https://github.com/gmateesc/ContainerizedWebApp/blob/master/GO/src/fizz_buzz/fizz_buzz.go">here</a>.


Building and running the Go program produces this output


<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/build_run_go.png" 
     alt="blob" width="520">




<a name="p6" id="p6"></a>
## Investigare the panic in the application


The web application is a Go application. The panic happens because the 
function converT2E  fails at some point, either because the arguments 
are wrong or because it cannot allocate the required memory.


Here is a screenshot of debugging the program with GDB and setting a breakpoint in 
the convT2E function


<img src="https://github.com/gmateesc/ContainerizedWebApp/blob/master/images/panic_convT2E.png" 
     alt="blob" width="520">



The developer should check all the arguments passed to functions and 
the possible errors returned by the functions. Whan that makes sense, 
code to recover from the error should be inserted.


