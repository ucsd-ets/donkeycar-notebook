FROM ucsdets/datahub-base-notebook:2022.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=4.4.0 DONKEYCAR_BRANCH=main

# https://github.com/mamba-org/mamba/issues/1403#issuecomment-1024629004
RUN apt install openssl && \
    conda update conda && \
    mamba update mamba

RUN mkdir /opt/local && \
    cd /opt/local && \
    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
    cd donkeycar && \
    mamba env create -f install/envs/ubuntu.yml && \
    eval "$(conda shell.bash hook)"

RUN mamba install -n donkey cudatoolkit=10.1 tensorflow-gpu=2.2.0 nb_conda_kernels openssl=1.1.1s -c anaconda -y && \
    chown -R jovyan /home/jovyan

RUN conda run -n donkey /bin/bash -c "ipython kernel install --name=donkey --display-name=\"Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)\""
RUN chown -R jovyan /opt/local

WORKDIR /opt/local/donkeycar
RUN conda run -n donkey /bin/bash -c "pip install -e .[pc]"

WORKDIR /home/jovyan

USER $NB_UID
