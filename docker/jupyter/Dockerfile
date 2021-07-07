FROM continuumio/miniconda3

RUN pip3 install mlflow jupyterlab json2html
#RUN pip install install ipython==7.10.0

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install curl git cmake ack g++ python3-dev vim-youcompleteme tmux -yq
RUN apt-get install g++-8 -yq
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/qooba/vim-python-ide/master/setup.sh)"
RUN pip3 install nbdev scikit-learn==0.24.2 cloudpickle==1.6.0 joblib==1.0.1 pandas numpy matplotlib tensorflow
RUN pip3 install boto3

CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --allow-root"]

