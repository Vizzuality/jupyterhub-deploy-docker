# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Pin to version of notebook image that includes start-singleuser.sh script
FROM jupyter/datascience-notebook:ubuntu-18.04

ARG PYTHON_VERSION=3.8
SHELL [ "/bin/bash", "-l", "-c" ]

USER root
ENV NVM_DIR /usr/local/nvm
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV GEOS_VERSION 3.8.0
ENV PROJ4_VERSION 6.3.1
ENV GDAL_VERSION 3.1.0
ENV ENCODING UTF-8
ENV LOCALE en_US

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
    python3-rtree \
    software-properties-common \
    graphviz \
    ca-certificates \
    build-essential \
    libsqlite3-dev \
    zlib1g-dev \
    manpages-dev \
    curl && \   
    add-apt-repository -y ppa:ubuntugis/ppa && add-apt-repository ppa:nextgis/ppa && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt update -q -y && \
    apt install -q -y  gdal-bin python3-gdal python-gdal libgdal-dev g++ && export CXX=g++ && \
	pip install jupyter_contrib_nbextensions version_information jupyterlab jupyterhub==1.1

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal && export C_INCLUDE_PATH=/usr/include/gdal

RUN jupyter contrib nbextension install --sys-prefix
RUN mkdir -p "$NVM_DIR"; \
    curl -o- \
        "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | \
        bash \
    ; \
    source $NVM_DIR/nvm.sh; \
    nvm install --lts --latest-npm
RUN npm install @mapbox/mapbox-gl-style-spec --global

Run git clone https://github.com/mapbox/tippecanoe.git && \
	cd tippecanoe && \
	make -j && make install && cd ..
RUN export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# Having to install gdal through conda gaves me chills; trying installing it through pip is failing badly. no time to dig depply on what is going on probably issues with path.
RUN conda install -c conda-forge python==3.8 python-blosc cytoolz gdal dask==2.17.2 xhistogram lz4 nomkl dask-labextension==2.0.2 python-graphviz tini==0.18.0
# Add requirements file 
ADD requirements.txt /srv/
Run pip install wheel -r /srv/requirements.txt

RUN jupyter nbextension install --sys-prefix --py vega && jupyter nbextension enable vega --py --sys-prefix && jupyter nbextension enable --py --sys-prefix ipyleaflet && jupyter labextension install @jupyter-widgets/jupyterlab-manager dask-labextension@2.0.2 

COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
ENTRYPOINT ["tini","-g", "--", "/srv/docker-entrypoint.sh"]
CMD ["start-singleuser.sh"]

USER jovyan

RUN mkdir /home/jovyan/work/data