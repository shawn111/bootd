# bootd - the lite version of bootc

[bootc](https://github.com/containers/bootc) is a great project, and I really like the idea of "Boot and upgrade via container images".
However, due to the developement history bootc is highly related with ostree and many other projects.

`bootd` would provide a simple way just rely on systemd / drucat / grub / [composefs](https://github.com/containers/composefs) make boot from container image as simple as possible.
The final goal is merged back to bootc project.

There are three parts

- build: build image from Containerfile, need handle kernel/initramfs(dracut)
- deploy: grub bls BootLoaderSpec
- boot: dracut module

## Prepare Containerfile

bootc don't support the way https://github.com/containers/bootc/blob/main/docs/src/bootc-images.md

```
FROM fedora
RUN dnf -y install kernel
```

But this way is really simple and can adoptable for most distroful Containerfile.
In order to boot, bootd still need add few requirements.

Containerfile
- require composefs
  - cfs-prepare-sysroot
- kernel / initramfs (dracut)


```
ARG base=docker.io/library/ubuntu:rolling

FROM $base as composefs
# prepare composefs


FROM $base
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y systemd ostree dracut
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y linux-image-generic

COPY --from=composefs /cfs/target/usr /usr

RUN mkdir -p /usr/lib/dracut/modules.d
COPY dracut.d /usr/lib/dracut/modules.d/80cfs-prepare-root
...

```


```
podman build -t localhost/bootc-ubuntu:latest . -f images/Containerfile.ubuntu
podman image mount localhost/bootc-ubuntu:latest


ln -s  sysroot/composefs composefs
/var/lib/containers/storage/overlay/98cf94224120f2355d5efc4df25632f6789c3b251f52cc0893562f959d72a7f6/merged

mkcomposefs /var/lib/containers/storage/overlay/98cf94224120f2355d5efc4df25632f6789c3b251f52cc0893562f959d72a7f6/merged --digest-store=/sysroot/composefs/repo /sysroot/composefs/images/bootc-cs9.cfs
```
