# What is this repository for?

- Dockerfile for generating a Docker container for building a specific Android SDK.

# Published as:

#### Image Names:

- **master:**
  `ultrarangers/android-build:latest`
- **android-API_NUMBER:** `ultrarangers/android-build:sdk-*`

#### Container Registry:

If you follow the branch name convention and pushed to `origin`, Bitbucket will integrate automatically to:

      https://hub.docker.com/r/ultrarangers/android-build/
      https://hub.docker.com/r/ultrarangers/android-build/tags/

# Building

#### Automated build

To create a Docker container for a specific Android API version, branch out from master or the latest branch using the naming convention

```
   # android-{API VERSION NUMBER}
   $ git branch android-27
```

The image tag name will be based on this later in the DockerHub automated build.

1. Create your folder:

```
  $ mkdir android-27
  $ cd android-27
```

2. Copy the other Dockerfile in the last version. In the Dockerfile, modify the variables with your version numbers: find the following lines and update accordingly.

```
    ...
    ENV ANDROID_API_VERSION 27
    ENV ANDROID_BUILD_TOOLS_VERSION 27.0.3
    ...
```

3. Just `git commit` and `git push` to `origin` with your branch name. Dockerhub will automatically build the container (see registry below).

4. in _master_, the git tag ANDROID_VERSION-SEQUENCE_NUMBER will be applied. This build will also overwrite the existing sdk-ANDROID_VERSION tag.

```
$ git tag 27-0
```

#### Custom tags

- For custom tags, you need to manually build. Use `docker build` and `docker push` like:

```
  $ docker build . -t ultrarangers/android-build:[your tag]
  $ docker push ultrarangers/android-build:[your tag]
```

# Usage

- To use your containers, in your CI file (e.g. bitbucket-pipelines.yml), just specify the image using the tag name. e.g.:

```
  image:ultrarangers/android-build:sdk-27
```
