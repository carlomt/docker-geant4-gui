# docker-geant4-gui

## Docker container with Geant4 and Qt5 to have Geant4 GUI

you can download this container with:

`docker pull carlomt/geant4-gui`

## Tags:

* [`latest`]
* [`centos`]

### Linux
I suggest to run it on linux with:

`docker run --net=host --env="DISPLAY" --user $(id -u):$(id -g) --volume="$HOME/docker_home/:$HOME" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="$HOME/.Xauthority:$HOME/.Xauthority:rw" --volume="$HOME/SOME_PATH/geant4-data:/opt/geant4/data" -it --rm carlomt/geant4-gui`

after having created a directory for the home user in the container:

`mkdir $HOME/docker_home/`

and a directory for the Geant4 datasets:

`mkdir $HOME/SOME_PATH/geant4-data`

it automatically check if the dataset is correctly installed, if not I suggest you to do so with:

`geant4-config --install-datasets`


### Mac Os

instructions done getting inspiration from: https://stackoverflow.com/questions/37826094/xt-error-cant-open-display-if-using-default-display

Make sure to install XQuartz (Updated with 2021 change)

install brew https://brew.sh/

install socat:

`brew install socat`

reboot your mac.

In MacOs the user information are not saved in a text file, I suggest to create such a file to pass it to the container:

`echo "$USER:x:$(id -u):$(id -g):$(id -F),,,:/home/$USER:/bin/bash" > ~/docker_home/.config/passwd`

You will need 2 terminals open: one for the socat with the display and the other for running Docker

 verify if there's anything running on port 6000:

`lsof -i TCP:6000`

If there is anything, just kill the process:

`kill -9 PROCESS_PID`

Open a socket on that port and keep the terminal open

`socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

on the second terminal run the container:

`docker run --net=host --env="DISPLAY" -e DISPLAY=docker.for.mac.host.internal:0 --user $(id -u):$(id -g) --volume="$HOME/docker_home/.config/passwd:/etc/passwd:ro" --volume="$HOME/docker_home/:/home/$USER" --volume="$HOME/.Xauthority:$HOME/.Xauthority:rw" --volume="$HOME/SOME_PATH/geant4-data:/opt/geant4/data" -it --rm carlomt/geant4-gui`

### Geant4 examples

The Geant4 examples are in the

`/opt/geant4/examples/`

folder inside the container. You do not have writing permission in that folder (and in its subfolder), I suggest you to copy the example you wish to modify in your home folder.


### Geant4 datasets

To keep the size of the Docker images limited, the Geant4 datasets are not installed. They expect to find the datasets in
`/opt/geant4/data`
I suggest you to map a folder in the host to use always the same dataset with the option:

`--volume="$HOME/SOME_PATH/geant4-data:/opt/geant4/data`

The image will check the datasets at login, if some are missing install them with:

`geant4-config  --install-datasets`
