# Pentest Docker Image

For isolated, near bare metal pentesting with Kali

## Instructions
1. `export DOCKERKALIPASSWORD="yourpasswordhere"`
1. `mkdir data_volume`
1. change `yourpasswordhere` in `Dockerfile` to your chosen password
1. Build the image with `docker-compose build`
2. Run the image with `docker-compose up -d`
3. Attach to the image with `docker attach kalidocker_dockerkali_1`
4. For more terminals, consider the following options:
  - using `tmux` (installed) or `screen` on the first terminal
  - Run `docker-compose exec dockerkali bash`
  - Run `docker exec -it kalidocker_dockerkali_1 bash`
4. the `/data_volume` directory is on the host mounted at `/data` inside docker to persist files
4. Run gui applications from the docker container:
  - On the host: `xhost +local:*`
  - In the container: `google-chrome`
  - Remove xhost permissions afterward: `xhost -local:*`
5. Detach with Ctrl+P then Ctrl+Q
