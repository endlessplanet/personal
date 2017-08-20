FROM docker/compose:1.7.0
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
WORKDIR /opt/docker
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD []
