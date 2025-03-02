#### Q1. Create a docker image with python installed in some alpine linux

> Answer
>
> ```Dockerfile
> FROM alpine:3.21.3
>
> LABEL author="Pritam Chakraborty" \
>    dateCreated="02-03-2025" \
>    purpose="to learn dockerfile"
>
> RUN apk update && \
>    apk add --no-cache bash && \
>    apk add --no-cache python3 py3-pip && \
>    ln -sf python3 /usr/bin/python
>
>
>
> COPY . /usr/app
>
> WORKDIR /usr/app
>
> ENTRYPOINT [ "python3" , "python.py" ]
> ```

#### Q2. Build image

> Answer:
>
> ```sh
> docker build -t pritamchk98/pyhton_hw_1:v1 -f pythonImg.Dockerfile .
>
> docker build -t pritamchk98/pyhton_hw_1:v2 -f pythonImg.Dockerfile .
>
> docker build  --no-cache -t pritamchk98/pyhton_hw_1:v2 -f pythonImg.Dockerfile .
> ```

#### Q3. Challenges faced

> Here I was using
>
> ```Dockerfile
> ENTRYPOINT ["python3" "python.ph"]
> ```

> so was getting error as I forgot to give `,` in between the command and params. initially I did not noticed that. So tried CMD Command like below :
>
> ```Dockerfile
> CMD sleep 600
> ```
>
> It was working with and warning like below
>
> ```log
>
> View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/5cn23524998knln0sehtfmqm8
>
> ```

> [!CAUTION]
>
> 1 warning found (use docker --debug to expand):
>
> - JSONArgsRecommended: JSON arguments recommended for CMD to prevent unintended behavior related to OS signals (line 20)
>
> ```
>
> then noticed that `,` and rebuild the image and ran the container
> ```

#### Q4. How to run this container

```sh
docker run -d pritamchk98/pyhton_hw_1:v2
```

#### Q5. how to clean dangling images or unused containers?

> [!TIP]
>
> ```sh
> docker container prune
>
> docker image prune
> ```

#### Q6. Push the image to `DOCKERHUB`

> Faced error:
>
> ```sh
> $ docker push pritamchk98/python_hw_1:v3
> The push refers to repository [docker.io/pritamchk98/python_hw_1]
> tag does not exist: pritamchk98/python_hw_1:v3
> ```
>
> Worked:
>
> ```sh
> docker push pritamchk98/pyhton_hw_1:v3
> The push refers to repository [docker.io/pritamchk98/pyhton_hw_1]
> 5f70bf18a086: Pushed
> 94c475a0226a: Pushed
> a76ba5dc04cf: Pushed
> 08000c18d16d: Mounted from library/alpine
> v3: digest: sha256:be53f9e67b7cd6245c4088b064574f069fe50bf85934038fc2b1638e134b895a size: 1153
> ```


#### Q7. Remove all images

>```sh
>docker image rm -f $(docker images -q)
>```

