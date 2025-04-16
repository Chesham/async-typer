ARG PYTHON_BIN=/opt/python/cp311-cp311/bin


FROM quay.io/pypa/manylinux_2_34_x86_64 AS dev

ARG PYTHON_BIN

ENV PATH="${PYTHON_BIN}:$PATH"

RUN yum install -y openssh-clients git bash-completion
RUN curl -fsSL https://download.docker.com/linux/centos/docker-ce.repo \
    -o /etc/yum.repos.d/docker-ce.repo \
    && yum install -y docker-ce-cli
RUN python -m pip install --upgrade pip twine
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt


FROM quay.io/pypa/manylinux_2_34_x86_64 AS build

ARG PYTHON_BIN

ENV PATH="${PYTHON_BIN}:$PATH"

RUN python -m pip install --upgrade pip twine

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY async_typer ./async_typer
COPY pyproject.toml README.md tox.ini ./
RUN tox
RUN python -m build
