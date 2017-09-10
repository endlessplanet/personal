FROM fedora:26
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]