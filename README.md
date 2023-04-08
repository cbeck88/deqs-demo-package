# deqs-demo-package

This repo helps you set up a minimal deployment of the deqs.

## Quick start

Start by getting a cloud machine somewhere.

I used [Amazon Lightsail](https://aws.amazon.com/free/compute/lightsail/?trk=56417dfe-8849-4622-bfa4-7ec30bd6f5a3&sc_channel=ps&ef_id=Cj0KCQjw_r6hBhDdARIsAMIDhV9mF7D1mX0JVrE8kVXF_gKbQw3GOy8Prk3Bc6AtwPdOZHMYgTAY3t4aAgMyEALw_wcB:G:s&s_kwcid=AL!4422!3!536323500429!e!!g!!amazon%20lightsail!11199789546!116615087504) with 4 GB RAM, 2 vCPUs, 80 GB SSD.

I configured a machine with OS-only and selected Ubuntu 22.04.

Then, get a prompt in the container. You will need to install supervisord.

```
sudo apt-get update && sudo apt-get install supervisor jq
```

You can use `wget` to fetch the pre-created package and install it with `tar`.
(Below we have a one-liner using `jq` that finds and fetches the latest release.)

```
sudo su
cd /
curl -s https://api.github.com/repos/cbeck88/deqs-demo-package/releases/latest | jq -r .assets[0].browser_download_url | wget -i -
tar -xzvf package.tar.gz
```

Then, run `supervisorctl`. You can use `help` to see available commands.
You can use `reload` to make it load all the configs you installed and start the services.

To monitor the services using `supervisorctl`, you can use the commands `status` and `tail -f mobilecoind` or `tail -f deqs` to look at logs.
You can also `stop` and `start` the services using `supervisorctl`.

You can also look at the `/var/log/mobilecoind.log` and `/var/log/deqs.log` files on disk, outside of `supervisorctl`.

## Ports and Networking

With the packaged configs, the deqs is started without TLS, listening on port 7000.

* This is `insecure-deqs://` scheme.
* You can modify `/etc/supervisord/conf.d/deqs.conf` if you want to change how it is launched.

I recommend that you

1. Click on the networking tab and configure a static ip.
1. Add a firewall rule allowing custom protocols to make TCP connections on port 7000.

If you have a static ip, you can set up an A record in DNS if you like.

## Testing that it is working

You can go to the deqs repository (or submodule of this repo) and run the test-cli.

```
./deqs-test-cli get-quotes --deqs-uri insecure-deqs://123.456.789.000
```

## Building the package

To build the package, start by checking out this repo and building the rust part.

```
git submodule update --recursive
./build_rust.sh
```

Then you can build the package, which produces `package.tar.gz`.

```
./make_package.sh
```

If you want to make a new release, simply tag whatever changes you made and attach `package.tar.gz` to the release.
