# Deqs-demo-package

This repo has submodules on the deqs, and william's deqs demo front end.
It contains a script that builds the requisite binaries and creates a tar ball.
This tar ball contains the needed binaries and supervisord conf's.

The idea is that you log into an ubuntu instance, `apt-get install supervisord`,
then unpack this tarball in the `/` of filesystem, and it should be good to go.
Subsequent deployment updates can be performed by rebuilding the tarball and unpacking it again.

I am planning to run this on an amazon lightsail container, and set up dns to point to it.
The deployment will be configured against testnet.
