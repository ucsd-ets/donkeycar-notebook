FROM ucsdets/datahub-base-notebook:2022.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=4.3.22 DONKEYCAR_BRANCH=main

RUN mkdir /opt/local && \
    cd /opt/local && \
    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
    cd donkeycar && \
    mamba env create -f install/envs/ubuntu.yml && \
    eval "$(conda shell.bash hook)"
RUN mamba install -n donkey cudatoolkit=10.1 tensorflow-gpu=2.2.0 -c anaconda -y && \
    chown -R jovyan /home/jovyan



RUN python -m ipykernel install --name=donkey --display-name="Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)"
RUN chown -R jovyan /opt/local

USER $NB_UID
RUN cd /opt/local/donkeycar && eval "$(conda shell.bash hook)" && conda activate donkey && \
    pip install -e .[pc]
#    conda install -c conda-forge --yes --quiet --verbose  cudatoolkit=10.1 && \

