FROM gitpod/workspace-full:latest

USER gitpod

RUN pip3 install tensorflow streamlit sklearn numpy matplotlib pandas
