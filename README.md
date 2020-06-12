# machine-learning

- my machine learning script

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/terasakisatoshi/machine-learning.git)

# Usage

- We will assume you're familiar with Docker/Docker Compose

## Build Docker images

- Just execute:

```console
$ docker-compose build
```

## Trying to run Python scripts on Jupyter Notebook/Lab

```console
$ docker-compose up jupyter # will initialize Jupyter Notebook
$ docker-compose up lab # will initialize JupyterLab
```

# Running Streamlit application

- The following command will initialize `app.py`

```console
$ docker-compose up streamlit
```
