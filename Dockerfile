ARG BASE_CONTAINER=ucsdets/scipy-ml-notebook:2019.4-stable
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# get donkeycar
RUN mkdir /opt/local && cd /opt/local && git clone https://github.com/autorope/donkeycar && \
	cd donkeycar && git checkout master && \
	python3 setup.py bdist_wheel

# install donkeycar into copy of tensorflow1 with all necessary dependencies using pip
# and remove tensorflow1 kernel
RUN pip install -e /opt/local/donkeycar[tf,tf_gpu] && \
	pip install numpy>=1.17.3

# RUN conda create --name donkey --clone base && \
# 	conda init bash && \
# 	chmod -R 777 /home/jovyan/.cache && \
# 	conda run -n donkey /bin/bash -c "pip install -e /opt/local/donkeycar[tf,tf_gpu]; ipython kernel install --name=donkey" && \
# 	chmod -R 6755 /home/jovyan/.cache

RUN rm -rf /home/jovyan/*.deb

USER $NB_UID
