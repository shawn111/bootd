build-ubuntu:
	podman build . -f images/Containerfile.ubuntu -t bootd-ubuntu
	# sudo build-cfs.sh bootd-ubuntu
