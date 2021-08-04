# Solution

# Containerize a PostgreSQL database with the application's schema

this solution pushed to the default dockerhub...

## Step 1

Using the Dockerfile at the bottom of this solution, first create a [docker volume](https://docs.docker.com/storage/volumes/), then the image. And test it all:

```sh
docker volume create footievol
docker build -t pgtest .
docker run --name footie -d -p 5432:5432 --mount source=footievol,target=/var/lib/postgresql/data pgtest
```

You can verify that the volume makes database changes persistent by removing the running docker container. In a bash shell (MacOS or Linux), you can do it as a one-liner via:

```sh
docker ps | grep pgtest | awk '{print $1}' | xargs docker rm -f
```

(of course, you need to be careful here, `docker rm -f` forces-removes whatever you pass it without any confirmations)

## Step 2

in step 1, you already created a working image. You can either re-create it here, with the correct tags to allow it to be pushed

```sh
docker build -t <your-dockerhub-username>/pgtest .
```

or just tag the image you created above:

```sh
docker tag pgtest <your-dockerhub-username>/pgtest
```

## Step 3

Now you just need to push the image. Note that you may need to first log in to the docker registry you are using

```sh
docker push <your-dockerhub-username>/pgtest
```
