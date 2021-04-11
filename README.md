# dockerize-solution

## Step 1

Using the Dockerfile in this project, first create a [docker volume](https://docs.docker.com/storage/volumes/), then the image. And test it all:

```sh
docker build -t pgtest .
docker run --name footie -d -p 5432:5432 --mount source=footie,target=/var/lib/postgresql/data pgtest
```

You can verify that the volume makes database changes persistent by removing the running docker container. In a bash shell (MacOS or Linux), you can do it as a one-liner via:

```sh
docker ps | grep pgtest | awk '{print $1}' | xargs docker rm -f
```

(of course, you need to be careful here, `docker rm -f` forces-removes whatever you pass it without any confirmations)

## Step 2

Kaniko runs as a container image. The easiest way to run this container locally is with ... Docker, of course. Kaniko will also push the image it creates to a container registry, in the same command, so the one-liner to do it all:

```sh
docker run -v $(pwd):/root -v $(pwd)/config.json:/kaniko/.docker/config.json:ro gcr.io/kaniko-project/executor:latest --dockerfile ./Dockerfile --context /root --destination <your-docker-username>/pgtest
```

where _/root_ is the context in the running image (specified in a couple of places). The _config.json_ that is passed into kaniko contains my (dockerhub)[https://hub.docker.com/] login username and password, base64-encoded. It looks something like this:

```json
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "Z3JcZrBofwplZ9dzYWiqXA=="
        }
    }
}
```

the _auth_ value is created via the command:

```sh
echo -n <docker-username>:<docker-password> | base64
```

the output string is the value for _auth_


Then you can again test the image by running:

```sh
docker run --name footie -d -p 5432:5432 --mount source=footie,target=/var/lib/postgresql/data <your-docker-username>/pgtest
```

Don't forget to remove the currently running local pgtest containers

```sh
docker ps | grep pgtest | awk '{print $1}' | xargs docker rm -f
```
