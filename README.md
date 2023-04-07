# deqs-demo-package

This repo helps you set up a minimal deployment of the deqs.

## Quick start

Start by getting a cloud machine somewhere.

I used Amazon Lightsail with 4 GB RAM, 2 vCPUs, 80 GB SSD.

Then, get a prompt in the container. You will need to install supervisord

```
sudo apt-get update && sudo apt-get install supervisor
```

You can use wget to fetch the pre-created package and install it with `tar`.

```
sudo su
cd /
wget https://github.com/cbeck88/deqs-demo-package/releases/download/v0.2/package.tar.gz
tar -xzvf package.tar.gz
```

Then, run `supervisorctl`. You can use `status` and `reload` to start the services.

To monitor the services using `supervisorctl`, you can use the commands `status` and `tail -f mobilecoind` or `tail -f deqs` to look at logs.
You can also `stop` and `start` the services using `supervisorctl`.

You can also look at the `/var/log/mobilecoind.log` and `/var/log/deqs.log` files on disk, outside of `supervisorctl`.

## Building the package

To build the package, start by checking out this repo and building the rust part.

```
git submodule update --recursive
./build_rust.sh
```

Then you can build the package, which produces `package.tar.gz`.

```
./build_package.sh
```

If you want to make a new release, simply tag whatever changes you made and attach `package.tar.gz` to the release.
