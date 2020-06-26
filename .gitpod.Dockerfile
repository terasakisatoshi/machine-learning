FROM gitpod/workspace-full:latest

USER root
RUN apt-get update && apt-get install -y \
    tree \
    htop \
    && apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

USER gitpod

RUN pip3 install streamlit sklearn numpy matplotlib pandas black pytest
