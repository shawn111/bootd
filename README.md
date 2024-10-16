# Bootc The Simple Way

[bootc](https://github.com/containers/bootc) is a great project, and I really like the idea of "Boot and upgrade via container images".
However, due to the developement history bootc is highly related with ostree and many other projects.

This repository would provide a simple way rely on systed / drucat / grub / composefs make boot from container image simple as possible.
The final goal is merged back to bootc project.

There are three parts

- build: build image from Containerfile, need handle kernel/initramfs(dracut)
- deploy: grub bls BootLoaderSpec
- boot: dracut module

## Build Bootable Container from Containerfile

Containerfile

- require composefs

```
FROM docker.io/library/ubuntu:rolling

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y systemd ostree dracut
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y linux-image-generic
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y dracut-config-generic
RUN mkdir -p /usr/lib/dracut/modules.d
COPY usr/lib/dracut/modules.d /usr/lib/dracut/modules.d

RUN apt install -y git autoconf m4 libglib2.0-dev libtool bison liblzma-dev e2fslibs-dev libgpgme-dev libsystemd-dev make libfuse3-dev
# libfuse-dev

RUN apt install -y gcc meson libssl-dev # openssl-dev fuse3-dev
RUN git clone https://github.com/containers/composefs.git /cfs
WORKDIR /cfs
RUN meson setup target --prefix=/usr --default-library=shared -Dfuse=enabled
RUN meson compile -C target
RUN meson install -C target

...
```


