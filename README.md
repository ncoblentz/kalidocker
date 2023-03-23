# Pentest Docker Image

For isolated, near bare metal pentesting with Kali

## Instructions
1. Build the image with `docker build . -t dockerkali:latest`
2. Run the image with `docker-compose up -d`
3. Attach to the image with `docker attach pentestkalidocker_dockerkali_1`
4. the `/data_volume` directory is on the host mounted at `/data` inside docker to persist files
4. Run gui applications from the docker container:
  - On the host: `xhost +local:*`
  - In the container: `google-chrome`
  - Remove xhost permissions afterward: `xhost -local:*`
5. Detach with Ctrl+P then Ctrl+Q
