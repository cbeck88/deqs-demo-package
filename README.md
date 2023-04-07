# deqs-demo-package

This repo helps you set up a minimal deployment of the deqs.

## Usage

Start by building the packaged software.

```
git submodule update --recursive
./build_rust.sh
```

Then you can build the package, which produces `package.tar.gz`.

```
./build_package.sh
```

To deploy, you can ssh to an ubuntu cloud machine.

You will need to have supervisord.

```
sudo apt-get install supervisord
```

Then, `scp` the package up, and unpack it in the root of the repo.

```
cd /
tar -xzf package.tar.gz
```

You can start, or check on the services, using `sudo supervisorctl`.

Subsequent deployment updates can be performed by rebuilding the tarball and unpacking it again.

## Details

I am planning to run this in an amazon lightsail container against testnet, and set up DNS to point to it.

This repo has submodules on the deqs repo, and on william's deqs-demo front end.
