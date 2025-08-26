FROM ucsdets/datahub-base-notebook:2022.3-stable

LABEL maintainer="UC San Diego ITS/ETS <datahub@ucsd.edu>"

USER root

ARG DONKEYCAR_VERSION=5.2.0 DONKEYCAR_BRANCH=main

# https://github.com/mamba-org/mamba/issues/1403#issuecomment-1024629004
RUN conda update conda && \
    mamba update mamba

RUN git clone https://github.com/autorope/donkeycar.git /opt/local/donkeycar && \
    cd /opt/local/donkeycar && \
    pip install -e .[pc]    
    
RUN chown -R jovyan /opt/local/donkeycar
WORKDIR /home/jovyan

USER $NB_UID

