# JAVA APP WITH MONGO AND MONGO EXPRESS
In this exercise you will create a docker-compose for a java application written with spring framework. Application is a Rest API which accepts POST requests to save movies in its database. It uses Mongo as its database. We want to deploy also Mongo-Express which is a management interface for Mongo, so an administrator can use it to see and manage Mongo databases.

User will access to the java app from outside, when user sends a request to java-app, java-app will send information to mongodb. User must also be able to access mongo-express from browser to see the databases on mongodb. So mongo-express needs to access mongo in order to show us what mongodb has inside. 

This is the flow, attention to the direction of arrows:

User/Client -> java-app -> mongodb <- mongo-express <- User/Client

## Movies java app
Its a typical application to build with maven, with a multistage Dockerfile
1. Use maven:3.6.3-jdk-11-slim as base image for the first stage
2. I'm not going to write here each step, because we already did it. So you must build the application with maven, first installing dependencies, then compiling source code.
3. In the second stage use  openjdk:11-jre-slim as base image. Copy the jar generated in the first stage and set entrypoint to launch this jar with java.
4. To see which port application listens on, build the image, launch a container and check logs.

## docker-compose.yml
docker-compose will have 3 services: java app, mongodb and mongo-express.
### java-app
1. Build java app with docker-compose. for the runtime configuration it needs 2 environment variables:
- MONGO_HOST: address of mongodb database (without port)
- MONGO_DB: database name to create a new database to save movies
No need to set username and password to authenticate to database.
2. Decide if this application needs to publish its port, if yes, publish it with the same port on host
### mongo
1. Deploy a mongodb by using mongo image from dockerhub with version 3.2.4
2. This timw, no need to set any environment variable for mongo
3. Decide if this application needs to publish its port, if yes, publish it with the same port on host
### mongo-express
1. Deploy mongo-express image from dockerhub with latest version
2. Since this application is the management interface for mongo, it must access to mongo. 
From its dockerhub page find the environment variable necessary to set mongodb address.
3. Again with documentation, find out which port application listens on. 
4. Decide if this application needs to publish its port, if yes, publish it on the port 9091 of your host.

## Verification
1. To check if application works correctly you(User/client) must try to add a movie to the database. So you must make a POST request, by using curl command, to the endpoint `http://127.0.0.1:<port>/api/v1/movie` with payload:
```
{"movieName" : "<put_here_a_movie_name>", "category" : "<add_movie_category>"}
```
If it works correctly, it will respond with the same payload.

2. You must also verify if mongo-express works correctly. You must check it from browser with the correct port. If you access it you can see databases created, so the database you created with MONGO_DB must be there.
