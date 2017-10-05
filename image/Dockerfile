FROM docker:17.09.0-ce
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["bash", "/opt/docker/entrypoint.sh"]
CMD []