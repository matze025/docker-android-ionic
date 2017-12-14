# docker-android-ionic

An Docker image for building Android and Ionic.

## Building Ionic
With the follwing command you can serve an IonicApp in the current directory.
Replace serve with the ionic command you like for other usages.
```bash
docker run -it --rm -p 8100:8100 -p 35729:35729 --privileged -v ~/.gradle:/root/.gradle -v $PWD:/workdir:rw matze025/android-ionic ionic serve
```

## Building Android 
With the follwing command you build am Android-App in the current directory.
```bash
docker run -it --rm -p 8100:8100 -p 35729:35729 --privileged -v ~/.gradle:/root/.gradle -v $PWD:/workdir:rw matze025/android-ionic ./gradlew assembleRelease
```

## Use npm and ionic with a bash alias
Install these aliases in your shell.
E.g. by putting them in the bash_profile or zshrc.
```bash
alias npm="docker run -it --rm -p 8100:8100 -p 35729:35729 --privileged -v ~/.gradle:/root/.gradle -v \$PWD:/workdir:rw matze025/android-ionic npm"
alias ionic="docker run -it --rm -p 8100:8100 -p 35729:35729 --privileged -v ~/.gradle:/root/.gradle -v \$PWD:/workdir:rw matze025/android-ionic ionic"
```
Afterwords you can use it, as normal.
E.g. You can do
```bash
ionic start --no-git myApp blank
cd myApp
ionic serve
```

## Updating
```bash
docker pull matze025/android-ionic:latest
```
