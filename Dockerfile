ARG BASE_CONTAINER=ucsdets/scipy-ml-notebook:2019.4-stable
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# get donkeycar
RUN mkdir /opt/local && cd /opt/local && git clone https://github.com/autorope/donkeycar && \
	cd donkeycar && git checkout master && \
	python3 setup.py bdist_wheel

# install donkeycar into copy of tensorflow1 with all necessary dependencies using pip
RUN pip install -e /opt/local/donkeycar[tf,tf_gpu] && \
	pip install 'numpy>=1.17.3'

USER $NB_UID
