FROM erlang:21.3.8-slim

RUN  apt-get -yq update && \
     apt-get -yqq install ssh && \
     apt-get install -y git

# install git
RUN apt-get update
RUN apt-get install -y git

# # add credentials on build
# ARG SSH_PRIVATE_KEY
# RUN mkdir /root/.ssh/
# RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa

# # avoiding error UNPROTECTED PRIVATE KEY FILE!
# RUN chmod 600 /root/.ssh/id_rsa

# # make sure your domain is accepted
# RUN touch /root/.ssh/known_hosts
# RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# RUN git clone git@github.com:ditas/es3.git
RUN git clone https://github.com/ditas/es3.git

COPY rebar3 es3/rebar3
RUN cd /es3/ && \
    rm -rf _build && \
    chmod +x rebar3 && \
    ./rebar3 as local release

## epmd's not working in docker
ENTRYPOINT ["es3/_build/local/rel/es3/bin/es3"]
CMD ["foreground"] 
# CMD sleep 9999999

# docker build -t es3-local .

# docker build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" -t es3-local .
# docker run -it -p 5551:5551 es3-local
# docker ps
# docker exec -it CONTAINER_ID /bin/bash