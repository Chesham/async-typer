FROM quay.io/pypa/manylinux2014_x86_64 AS test

ENV PATH="/opt/python/cp311-cp311/bin:$PATH"
RUN python -m pip install --upgrade pip

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY async_typer async_typer
COPY pyproject.toml pyproject.toml
COPY README.md README.md
COPY tox.ini tox.ini
RUN tox


FROM quay.io/pypa/manylinux2014_x86_64 AS build

ENV PATH="/opt/python/cp311-cp311/bin:$PATH"
RUN python -m pip install --upgrade pip

WORKDIR /app

COPY async_typer async_typer
COPY pyproject.toml pyproject.toml
COPY README.md README.md
RUN python -m build
