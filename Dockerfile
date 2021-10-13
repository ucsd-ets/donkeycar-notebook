FROM ucsdets/scipy-ml-notebook:2021.3-stable
#FROM ucsdets/scipy-ml-notebook:2021.2.2

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# get donkeycar
ENV DONKEYVER=4.3.0 DONKEYCAR_BRANCH=dev 
#RUN mkdir /opt/local && \
#    cd /opt/local && \
#    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
#    cd donkeycar && \
#    python3 setup.py bdist_wheel

# install donkeycar into copy of tensorflow1 with all necessary dependencies using pip

###
RUN mkdir /opt/local && \
    eval "$(conda shell.bash hook)" && \
#    conda create --name myenv   && \
#    conda activate myenv
###

    cd /opt/local && \
    git clone https://github.com/autorope/donkeycar -b $DONKEYCAR_BRANCH && \
    cd donkeycar && \

#    git checkout dev && \
#conda update -n base -c defaults conda && \
#conda env remove -n donkey && \
#    conda update -n base -c defaults conda && \
    #source ~/anaconda3/etc/profile.d/conda.sh && \

###
    conda env remove -n donkey && \
#    conda create --name donkey && \
    conda env create -f install/envs/ubuntu.yml && \
    conda activate donkey && \
    pip install -e .[pc] && \
    conda install -c anaconda ipykernel && \
    python -m ipykernel install --name=donkeycar --display-name="Donkey Car"

###
#RUN conda install cudnn=8.2.1



#RUN conda install cudnn=7.6.5
#RUN pip install -e /opt/local/donkeycar[tf,tf_gpu] && \
#    pip install tensorflow-gpu==2.2.0
#RUN pip install git+https://github.com/autorope/donkeycar.git@dev

USER $NB_UID
