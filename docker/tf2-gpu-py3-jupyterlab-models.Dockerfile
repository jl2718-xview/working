FROM tensorflow/tensorflow:2.0.0b0-gpu-py3-jupyter

RUN apt-get -yq update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get -y install python3-tk git unzip wget curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -yq nodejs

RUN pip install --upgrade pip
RUN pip install Cython
RUN pip install contextlib2 lxml pycocotools pillow
RUN pip install jupyterlab ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

RUN wget --quiet https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip -O protoc.zip && unzip -j protoc.zip bin/protoc -d /bin && rm protoc.zip

# RUN git clone --depth 1 https://github.com/tensorflow/models.git
RUN wget --quiet https://github.com/tensorflow/models/archive/master.zip -O models.zip  && unzip models.zip && rm models.zip && mv models-master models
RUN cd models/research && \
    protoc object_detection/protos/*.proto --python_out=. && \
    python setup.py install && \
    echo "export PYTHONPATH=${PYTHONPATH}:`pwd`:`pwd`/slim" >> /etc/bash.bashrc && \
    cd ../..

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter lab --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]
