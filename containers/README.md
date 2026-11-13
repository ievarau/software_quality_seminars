# Container tutorial (Docker, Podman, Apptainer)

This directory now has two minimal examples:

- `container_A`: Python + seaborn
- `container_B`: R + ggplot2

## 1) Python example (`container_A`)

### Docker
```bash
cd container_A
docker build -t tutorial-python-seaborn .
docker run --rm -v "$PWD:/app" tutorial-python-seaborn
```

### Podman
```bash
cd container_A
podman build -t tutorial-python-seaborn .
podman run --rm -v "$PWD:/app:Z" tutorial-python-seaborn
```

### Apptainer
```bash
cd container_A
apptainer build python-seaborn.sif apptainer.def
apptainer run python-seaborn.sif
```

### Interactive shell
```bash
cd container_A
docker run --rm -it -v "$PWD:/app" --entrypoint /bin/bash tutorial-python-seaborn
podman run --rm -it -v "$PWD:/app:Z" --entrypoint /bin/bash tutorial-python-seaborn
apptainer shell python-seaborn.sif
```

Expected output file: `seaborn_plot.png`

---

## 2) R example (`container_B`)

### Docker
```bash
cd container_B
docker build -t tutorial-r-ggplot2 .
docker run --rm -v "$PWD:/app" tutorial-r-ggplot2
```

### Podman
```bash
cd container_B
podman build -t tutorial-r-ggplot2 .
podman run --rm -v "$PWD:/app:Z" tutorial-r-ggplot2
```

### Apptainer
```bash
cd container_B
apptainer build r-ggplot2.sif apptainer.def
apptainer run r-ggplot2.sif
```

### Interactive shell
```bash
cd container_B
docker run --rm -it -v "$PWD:/app" --entrypoint /bin/bash tutorial-r-ggplot2
podman run --rm -it -v "$PWD:/app:Z" --entrypoint /bin/bash tutorial-r-ggplot2
apptainer shell r-ggplot2.sif
```

Expected output file: `ggplot2_plot.png`

## Tagging and pushing to a registry (Docker Hub example)

If you want to publish any of the images to Docker Hub, first log in with your Docker Hub account:

```bash
docker login -u cbgr
```

Then either build directly with the registry tag, or tag an existing local image before pushing:

```bash
# Build and tag in one step
cd container_A
docker build -t cbgr/tutorial-python-seaborn:latest .

# Or tag an existing local image
# docker tag tutorial-python-seaborn cbgr/tutorial-python-seaborn:latest

docker push cbgr/tutorial-python-seaborn:latest
```

You can also use a version tag instead of `latest`:

```bash
cd container_B
docker build -t cbgr/tutorial-r-ggplot2:1.0.0 .
docker push cbgr/tutorial-r-ggplot2:1.0.0
```

To pull the image back later:

```bash
docker pull cbgr/tutorial-python-seaborn:latest
```

You can also pull a container directly from Docker Hub without building it locally:

```bash
docker pull cbgr/tutorial-python-seaborn:latest
```

This downloads the image from the registry to your local machine. Once it is downloaded, you can run it as usual:

```bash
docker run --rm cbgr/tutorial-python-seaborn:latest
```

If you want to pull a specific version or tag instead of `latest`:

```bash
docker pull cbgr/tutorial-r-ggplot2:1.0.0
```

## Checking what is available locally

Docker keeps a list of both images and running containers. The main commands are:

```bash
# Show all local images (downloaded or built)
docker images

# Show all running containers
docker ps

# Show all containers, including stopped ones
docker ps -a
```

What each term means:

- Image: a packaged filesystem snapshot of an application and its dependencies. It is what you `build` and `pull`.
- Container: a running instance created from an image. It is what you `run`.
- `docker images`: lists available local images and their tags, such as `cbgr/tutorial-python-seaborn:latest`.
- `docker ps`: lists only currently running containers.
- `docker ps -a`: lists all containers, even ones that have exited or stopped.

Example:

```bash
docker images
docker ps -a
```

This helps you see what was built, downloaded, or previously run.

## Volumes and mounting

A volume or bind mount lets a container access files from the host machine. This is useful when you want to edit code on your machine while running it inside the container.

Example:

```bash
docker run --rm -v "$PWD:/app" tutorial-python-seaborn
```

This means:

- `$PWD` on the host machine is mapped to `/app` inside the container
- the container can read and write files in that directory
- changes made in the container to files under `/app` are visible on the host, and vice versa

For Podman, the same pattern is often used, but on SELinux systems you typically need `:Z`:

```bash
podman run --rm -v "$PWD:/app:Z" tutorial-python-seaborn
```

What `:Z` does:

- it tells Podman to relabel the bind-mounted directory for SELinux compatibility
- this prevents permission issues when the container and host use different SELinux security contexts
- it is mainly needed on Linux distributions with SELinux enabled, such as Fedora, RHEL, and some CentOS setups

Without `:Z`, Podman may fail to read/write files in the mounted directory, especially when the volume is used for project source code or output files.

In short:

- `-v "$PWD:/app"` = bind mount a host directory into the container
- `:Z` = extra SELinux labeling for safe sharing with Podman on SELinux systems

## Notes

- Apptainer build may require `sudo` or fakeroot, depending on your setup.
