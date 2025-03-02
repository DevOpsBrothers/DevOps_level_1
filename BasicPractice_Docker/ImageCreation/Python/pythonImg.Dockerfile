FROM alpine:3.21.3

LABEL author="Pritam Chakraborty" \
    dateCreated="02-03-2025" \
    purpose="to learn dockerfile"

RUN apk update && \
    apk add --no-cache bash && \
    apk add --no-cache python3 py3-pip && \
    ln -sf python3 /usr/bin/python 
# && \
# pip3 install --no-cache --upgrade pip setuptools


COPY . /usr/app

WORKDIR /usr/app

# ENTRYPOINT [ "python3" , "python.py" ]
CMD sleep 120
