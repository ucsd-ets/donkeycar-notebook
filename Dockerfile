ARG BASE_CONTAINER=ucsdets/scipy-ml-notebook:2019.4.6
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# Remove existing scipy-ml TF version in favor of Donkeycar's preference
RUN conda remove tensorflow'*' tensorboard keras-'*' --force

# Ended up installing Tensorflow via PIP - using conda may have
# given us mismatched versions of TF and TF-gpu, rendering GPU unusable.

# Rather than using the following (essentially following Donkey docs):
#        conda env update -n base --file install/envs/ubuntu.yml --prune && \
# we must install them manually because "conda env update" doesn't support a "--freeze-installed" option
# and we don't want to broadly upgrade all packages in our base image.
# Future enhancement might be to use a one-liner Python script to extract package names
# from the .yml file at runtime
RUN mkdir /opt/local && cd /opt/local && git clone https://github.com/autorope/donkeycar && \
	cd donkeycar && git checkout master &&  \
	sha256sum install/envs/ubuntu.yml && \
	( [ "$(sha256sum install/envs/ubuntu.yml | cut -c 1-64)" = "8f373039c6b0607893c4b9049ca4da6e1efde9511187b549345574a41bb9d0b7" ] || ( echo "Signature on ubuntu.yml changed; check manual package list" && false ) ) &&  \
	pip install tensorflow-gpu==1.13.1 && \
	conda install --yes --freeze-installed -n base \
		h5py \
		pillow \
		opencv \
		matplotlib \
		tornado \
		docopt \
		pandas \
		pylint \
		pytest \
		pip \
	&& \
	pip install moviepy paho-mqtt PrettyTable && \
	pip install -e . 

USER $NB_UID
