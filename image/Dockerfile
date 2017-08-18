FROM docker/compose:1.6.2
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
WORKDIR /opt/docker
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD []
