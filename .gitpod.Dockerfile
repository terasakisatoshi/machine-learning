FROM gitpod/workspace-full:latest

USER gitpod

RUN pip3 install tensorflow streamlit sklearn numpy matplotlib pandas
RUN pip3 install \
    jupyter \
    jupyterlab \
    jupytext \
    jupyter_contrib_nbextensions \
    jupyterlab_code_formatter \
    black \
    pytest

RUN mkdir ${HOME}/.jupyter && echo "\
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
