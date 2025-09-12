FROM ghcr.io/ucsd-ets/datascience-notebook:2025.2-stable

# LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=5.2.0 DONKEYCAR_BRANCH=main

# https://github.com/mamba-org/mamba/issues/1403#issuecomment-1024629004 
RUN mamba update conda mamba
    
# RUN mamba install -n base 'jupyterlab>=4' 'notebook>=7' jupyter_server -y

RUN mamba create -n donkey python=3.11 -y

RUN git clone https://github.com/autorope/donkeycar.git /opt/local/donkeycar

RUN conda run -n donkey /bin/bash -c " \
    cd /opt/local/donkeycar && \
    pip install -e .[pc] "

RUN mamba install -n donkey nb_conda_kernels -y
    
RUN conda run -n donkey /bin/bash -c " \
    ipython kernel install --name=donkey --display-name=\"Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)\""
    
ENV CONDA_DEFAULT_ENV=base
ENV PATH=/opt/conda/envs/base/bin:$PATH

RUN which python && python --version && jupyter --version

RUN chown -R jovyan /opt/local /opt/conda
WORKDIR /home/jovyan

USER $NB_UID
