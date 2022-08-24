FROM ucsdets/datahub-base-notebook:2022.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=4.3.22 DONKEYCAR_BRANCH=main

# https://github.com/mamba-org/mamba/issues/1403#issuecomment-1024629004
RUN conda update conda && \
    mamba update mamba && \
    pip install ipykernel==6.7.0

RUN mkdir /opt/local && \
    cd /opt/local && \
    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
    cd donkeycar && \
    mamba env create -f install/envs/ubuntu.yml && \
    eval "$(conda shell.bash hook)"
RUN mamba install -n donkey cudatoolkit=10.1 tensorflow-gpu=2.2.0 nb_conda_kernels -c anaconda -y && \
    chown -R jovyan /home/jovyan

RUN python -m ipykernel install --name=donkey --display-name="Donkey Car ($DONKEYCAR_VERSION-$DONKEYCAR_BRANCH)"
RUN chown -R jovyan /opt/local

USER $NB_UID
RUN cd /opt/local/donkeycar && eval "$(conda shell.bash hook)" && conda activate donkey && \
    pip install -e .[pc]
#    conda install -c conda-forge --yes --quiet --verbose  cudatoolkit=10.1 && \

