FROM python:3.8-slim-buster

LABEL "maintainer"="Miles Smith <miles-smith@ormf.org>"
LABEL "original-author"="Tudor Marghidanu"
LABEL "based-on"="stuffox/jupyter-perl"

ENV JUPYTER_PORT 8080
ENV JUPYTER_IP 0.0.0.0
ENV JUPYTER_NOTEBOOK_DIR /opt/jupyter
ENV DEBIAN_FRONTEND=noninteractive

# Installing dependencies
RUN apt-get update --fix-missing && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y \
        build-essential \
        curl \
        git-core \
        pkg-config \
        libcairo2-dev \
        libzmq3-dev \
        ssh \
        vim && \
    cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    apt-get clean && \
    rm -rf /tmp/downloaded_packages/* && \
    rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install jupyter pandas numpy cython ipython

# Installing IPerl without tests ...
RUN curl -sL http://cpanmin.us | perl - App::cpanminus \
    && /usr/local/bin/cpanm --notest Devel::IPerl \
        PDL \
        Moose \
        MooseX::AbstractFactory \
        MooseX::AbstractMethod \
        MooseX::Storage \
        Test::More

EXPOSE $JUPYTER_PORT

VOLUME $JUPYTER_NOTEBOOK_DIR

RUN mkdir -p $JUPYTER_NOTEBOOK_DIR
WORKDIR $JUPYTER_NOTEBOOK_DIR

ENTRYPOINT iperl notebook --port $JUPYTER_PORT --ip $JUPYTER_IP --notebook-dir $JUPYTER_NOTEBOOK_DIR --allow-root 