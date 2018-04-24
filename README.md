

### What is this repository for? ###

* Dockerfile for generating a Docker container for building a specific Android SDK.


### Published as:
##### Image Names:
* **master:** `ultrarangers/android-build:latest` (CI CURRENTLY DISABLED)
* **android-*:** `ultrarangers/android-build:sdk-*`


##### Container Registry:
If you follow the branch name convention and pushed to `origin`, Bitbucket will integrate automatically to:
      https://hub.docker.com/r/ultrarangers/android-build/
      https://hub.docker.com/r/ultrarangers/android-build/tags/

### Building
##### Automated build
* To create a Docker container for a specific Android API version, branch out from master or the latest branch using the naming convention

        android-{API VERSION NUMBER}
    e.g.

        android-27

    The image tag name will be based on this later in the DockerHub automated build.

1. In the Dockerfile, modify the variables with your version numbers:
Find the following lines and update accordingly.
```
    ...
    ENV ANDROID_API_VERSION 27
    ENV ANDROID_BUILD_TOOLS_VERSION 27.0.3
    ...
```
2. Just `git commit` and `git push` to `origin` with your branch name. Dockerhub will automatically build the container (see registry below).

##### Custom
* For custom tags, you need to manually build. Use `docker build` and `docker push` like:

      docker build . -t ultrarangers/android-build:[your tag]
      docker push ultrarangers/android-build:[your tag]



#### Usage
* To use your containers, in your CI file (e.g. bitbucket-pipelines.yml), just specify the image using the tag name. e.g.:

      image:ultrarangers/android-build:sdk-27
