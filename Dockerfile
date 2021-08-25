FROM ucsdets/scipy-ml-notebook:2021.2.2

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# get donkeycar
ENV DONKEYVER=4.3.0
RUN mkdir /opt/local && cd /opt/local && git clone https://github.com/autorope/donkeycar && \
        cd donkeycar && git checkout master && \
        python3 setup.py bdist_wheel

# install donkeycar into copy of tensorflow1 with all necessary dependencies using pip
RUN pip install -e /opt/local/donkeycar[tf,tf_gpu]
RUN conda install cudnn && \
    pip install tensorflow-gpu==2.2.0

USER $NB_UID
