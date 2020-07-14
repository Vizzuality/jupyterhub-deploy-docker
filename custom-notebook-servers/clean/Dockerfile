# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Pin to version of notebook image that includes start-singleuser.sh script
FROM jupyter/scipy-notebook

RUN pip install --no-cache jupyterhub==1.1

# Install packages in default Python 3 environment
RUN pip install \
  beautifulsoup4==4.4.* \
  nbgitpuller

# Use custom startup script
USER root
COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
ENTRYPOINT ["tini","-g", "--", "/srv/docker-entrypoint.sh"]
CMD ["start-singleuser.sh"]

USER jovyan

RUN mkdir /home/jovyan/data