FROM fedora:latest

ARG BUILD_DATE

LABEL summary="A container that is used the github action graphviz."
LABEL maintainer="Uco Mesdag <uco@mesd.ag>"
LABEL build-date=${BUILD_DATE}

WORKDIR /github/workspace

ADD make_dot.sh /make_dot.sh
ADD make_png.sh /make_png.sh

RUN dnf install -y graphviz \
    python3-pip \
    ImageMagick && \
    dnf clean all

RUN pip install shyaml

CMD cd ${GITHUB_REPOSITORY} && sh /make_dot.sh && sh /make_png.sh
