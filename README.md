# docker-geant4-gui

## Docker container with Geant4 and Qt5 to have Geant4 GUI

I suggest to run it on linux with:

`docker run --net=host --env="DISPLAY" --user $(id -u):$(id -g) --volume="$HOME/docker_home/:$HOME" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="$HOME/.Xauthority:$HOME/.Xauthority:rw" --volume="$HOME/SOME_PATH/geant4-data:/opt/geant4/data" -it --rm carlomt/geant4-gui`

after having created a directory for the home user in the container:
`mkdir $HOME/docker_home/`
and a directory for the Geant4 datasets:
`mkdir $HOME/SOME_PATH/geant4-data`
it automatically check if the dataset is correctly installed, if not I suggest you to do so with:
`geant4-config --install-datasets`

