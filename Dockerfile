FROM centos:centos7
ADD image /hbb_build
ARG DISABLE_OPTIMIZATIONS=0
RUN bash /hbb_build/build.sh
