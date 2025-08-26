FROM ucsdets/datahub-base-notebook:2022.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=5.2.0 DONKEYCAR_BRANCH=main

# https://github.com/mamba-org/mamba/issues/1403#issuecomment-1024629004
RUN conda update conda && \
    mamba update mamba
    
RUN mamba install -n base jupyterlab notebook jupyter_server -y

RUN mamba create -n donkey python=3.11 -y

RUN conda run -n donkey /bin/bash -c " \
    git clone https://github.com/autorope/donkeycar.git /opt/local/donkeycar && \
    cd /opt/local/donkeycar && \
    pip install -e .[pc] && \
    pip install nb_conda_kernels"
    
RUN conda run -n donkey /bin/bash -c " \
    ipython kernel install --name=donkey --display-name=\"Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)\""
    
RUN chown -R jovyan /opt/local
WORKDIR /home/jovyan

USER $NB_UID
