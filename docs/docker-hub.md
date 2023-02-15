# Building Docker

This application is available as a Docker image in:
https://cloud.docker.com/u/microstudi/repository/docker/microstudi/decidim-hacks

To build a new image we use the `Dockerfile` file:

```
sudo docker build . -t microstudi/decidim-hacks:VERSION
```

To upload it to the Docker hub (permissions needed):

```
sudo docker login
sudo docker push microstudi/decidim-hacks:VERSION
sudo docker tag microstudi/decidim-hacks:VERSION microstudi/decidim-hacks:latest
sudo docker push microstudi/decidim-hacks:latest
```
