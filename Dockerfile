FROM jupyter/scipy-notebook

# Install dev packages
RUN conda install -y -c conda-forge \
    black \
    jupytext \
    pytest \
    jupyter_contrib_nbextensions \
    jupyterlab_code_formatter \
    && \
    conda clean --all -f -y

RUN echo "\
c.ContentsManager.default_jupytext_formats = 'ipynb,py'\n\
c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'\n\
c.NotebookApp.open_browser = False\n\
" >> ${HOME}/.jupyter/jupyter_notebook_config.py

# prepare to install extension
RUN jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    # enable extensions what you want
    jupyter nbextension enable select_keymap/main && \
    jupyter nbextension enable highlight_selected_word/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable toc2/main && \
    jupyter nbextension enable equation-numbering/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    echo Done

# Install/enable extension for JupyterLab users
RUN jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @z-m-k/jupyterlab_sublime --no-build && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build && \
    jupyter serverextension enable --py jupyterlab_code_formatter && \
    jupyter labextension install @hokyjack/jupyterlab-monokai-plus --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    echo Done

# Setup default formatter (For Python Users only)
RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter && echo '\
{\n\
    "preferences": {\n\
        "default_formatter": {\n\
            "python": "black",\n\
        }\n\
    }\n\
}\n\
\
'>> ${HOME}/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

# Set color theme Monokai++ by default (The selection is due to my hobby)
RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && echo '\
{\n\
    "theme": "Monokai++"\n\
}\n\
\
' >> ${HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

# Show line numbers by default
RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@jupyterlab/notebook-extension && echo '\
{\n\
    "codeCellConfig": {\n\
        "lineNumbers": true,\n\
    },\n\
}\n\
\
' >> ${HOME}/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

RUN pip install tensorflow streamlit && \
    conda install -c conda-forge opencv && \
    conda clean --all -f -y

RUN mkdir -p ${HOME}/.streamlit
RUN bash -c 'echo -e "\
[general]\n\
email = \"\"\n\
" > ${HOME}/.streamlit/credentials.toml'
# exposing default port for streamlit
EXPOSE 8501
EXPOSE 8888

# Julia dependencies
ENV JULIA_VERSION=1.4.2
ENV PATH="${HOME}/julia-${JULIA_VERSION}/bin":$PATH
# This technique is taken from jupyter/docker-stacks project
RUN mkdir "${HOME}/julia-${JULIA_VERSION}" && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/$(echo "${JULIA_VERSION}" | cut -d. -f 1,2)"/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    echo "d77311be23260710e89700d0b1113eecf421d6cf31a9cebad3f6bdd606165c28 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" -C "${HOME}/julia-${JULIA_VERSION}" --strip-components=1 && \
    rm "./julia-${JULIA_VERSION}-linux-x86_64.tar.gz"

RUN julia -e 'using Pkg; Pkg.add(["Plots", "PackageCompiler"])'
# Install kernel so that `JULIA_PROJECT` should be $JULIA_PROJECT
RUN jupyter nbextension uninstall --user webio/main && \
    jupyter nbextension uninstall --user webio-jupyter-notebook && \
    julia -e '\
              using Pkg; \
              Pkg.add(PackageSpec(name="IJulia", version="1.21.2")); \
              Pkg.add(PackageSpec(name="WebIO", version="0.8.14")); \
              Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
              Pkg.pin(["IJulia", "WebIO","Interact"]); \
              using IJulia, WebIO; \
              WebIO.install_jupyter_nbextension(); \
              envhome="/work"; \
              installkernel("Julia", "--project=$envhome", "-J/sysimages/ijulia.so");\
              ' && \
    echo "Done"
RUN mkdir -p ${HOME}/sysimages && julia -e 'using PackageCompiler; create_sysimage([:Plots], sysimage_path="$(homedir())/sysimages/plots.so")'
RUN julia -e 'using Pkg; Pkg.precompile()'
