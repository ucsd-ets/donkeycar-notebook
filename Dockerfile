FROM ucsdets/scipy-ml-notebook:2021.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=4.3.0 DONKEYCAR_BRANCH=dev

RUN mkdir /opt/local && \
    cd /opt/local && \
    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
    cd donkeycar && \
    conda env create -f install/envs/ubuntu.yml && \
    eval "$(conda shell.bash hook)" && \
    conda activate donkey && \
    pip install -e .[pc] && \
    conda install -c anaconda ipykernel && \
    pip install tensorflow-gpu==2.2.0 cudatoolkit=10.1 && \
    python -m ipykernel install --name=donkeycar --display-name="Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)"

USER $NB_UID
