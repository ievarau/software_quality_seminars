# Container tutorial (Docker, Podman, Apptainer)

## Key concepts

**Container runtime** — the program that runs containers. This tutorial covers three:

- **Docker**: the most widely used container runtime; requires a daemon running as root.
- **Podman**: a daemonless, rootless alternative to Docker with a nearly identical CLI; better suited for shared HPC-style systems.
- **Apptainer** (formerly Singularity): designed for HPC environments where users cannot run as root; uses a single `.sif` archive file per image.

**Image** — a read-only, layered snapshot of a filesystem bundled with everything an application needs to run: OS libraries, language runtimes, dependencies, and code. Images are what you `build`, `pull`, and `push`. They live on disk until you explicitly delete them.

**Container** — a running (or stopped) instance created from an image. Each `docker run` or `podman run` spawns a new container from the same image. Multiple containers can run from the same image at the same time without interfering with each other.

**Dockerfile / Containerfile** — a text file with step-by-step instructions for building an image (e.g., which base image to start from, which packages to install, which files to copy in). Docker uses `Dockerfile`; Podman accepts both `Dockerfile` and `Containerfile`.

**Apptainer definition file (`.def`)** — the Apptainer equivalent of a Dockerfile; describes how to build a `.sif` image.

**Tag** — a human-readable label attached to an image, in the form `name:version` (e.g., `cbgr/tutorial-python-seaborn:latest` or `cbgr/tutorial-r-ggplot2:1.0.0`). `latest` is the default tag when none is specified.

**Registry** — a remote storage service for images, such as Docker Hub. Images are `push`ed to and `pull`ed from a registry to share them across machines.

**Volume / bind mount** — a way to make a directory on your host machine accessible inside a running container, so the container can read inputs and write outputs back to disk.

---

This directory has two minimal examples:

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

## Managing local containers and images

### Listing what is available

```bash
# Show all local images (downloaded or built)
docker images

# Show all running containers
docker ps

# Show all containers, including stopped ones
docker ps -a
```

Run these first to see what is built, downloaded, or previously run before deciding what to remove.

### Check disk usage

```bash
docker system df
```

This shows how much space is used by images, containers, and build cache, and how much could be reclaimed.

### Stopping a running container

The containers in this tutorial exit on their own once the script finishes. If you are running a long-lived or interactive container and need to stop it manually:

```bash
# Find the container ID or name
docker ps

# Stop it gracefully (sends SIGTERM, waits up to 10 s, then SIGKILL)
docker stop <container_id>

# Stop immediately without waiting
docker stop -t 0 <container_id>
```

From inside an interactive shell session (`docker run -it ...`), you can also just type `exit` or press `Ctrl+D`.

Podman uses the same commands:

```bash
podman ps
podman stop <container_id>
```

Apptainer instances (started with `apptainer instance start`) are stopped with:

```bash
apptainer instance stop <instance_name>

# Stop all running instances
apptainer instance stop --all
```

A plain `apptainer run` or `apptainer exec` runs in the foreground and exits when the command finishes; `Ctrl+C` interrupts it like any other foreground process.

### Remove stopped containers

```bash
# Remove a specific stopped container by ID (use docker ps -a to find it)
docker rm <container_id>

# Remove all stopped containers at once
docker container prune
```

### Remove images

```bash
# Remove a specific image by name or ID (use docker images to find it)
docker rmi tutorial-python-seaborn
docker rmi cbgr/tutorial-r-ggplot2:1.0.0

# Remove all dangling images (untagged, not referenced by any container)
docker image prune

# Remove all unused images (dangling + images not used by any container)
docker image prune -a
```

### Remove everything unused at once

```bash
# Remove all stopped containers, dangling images, unused networks, and build cache
docker system prune

# Also include unused images (not just dangling ones) — frees the most space
docker system prune -a
```

Both commands ask for confirmation before deleting anything. Add `-f` to skip the prompt.

### Podman equivalents

Podman uses the same commands and flags:

```bash
podman images
podman ps -a
podman system df
podman container prune
podman image prune -a
podman system prune -a
```

### Apptainer / Singularity

Unlike Docker and Podman, Apptainer/Singularity does not have a background daemon or container database. However, disk space is consumed in two main places: **`.sif` image files** and the **build/download cache**.

#### 1. Removing `.sif` image files
Apptainer `.sif` files are plain standalone files on your filesystem. You can list and delete them using standard shell commands:

```bash
# List all .sif files in current directory
ls -lh *.sif

# Delete specific .sif images
rm python-seaborn.sif r-ggplot2.sif
```

#### 2. Managing cache
When pulling images from Docker Hub/registries or building from definition files, Apptainer/Singularity caches downloaded layers, blobs, and OCI conversions in `~/.apptainer/cache` (or `~/.singularity/cache`). On HPC systems with limited home directory quotas, this cache can fill up quickly.

```bash
# View cache usage and location
apptainer cache list -v
# For singularity:
# singularity cache list -v

# Clean everything from the cache (prompts for confirmation; add -f to force)
apptainer cache clean
# For singularity:
# singularity cache clean

# Clean only specific cache types (e.g., oci-tmp, blob, or library)
apptainer cache clean -t oci-tmp
```

#### 3. Stopping and cleaning running instances
If you used background instances (`apptainer instance start ...`), make sure they are stopped:

```bash
# List active instances
apptainer instance list

# Stop a specific instance
apptainer instance stop <instance_name>

# Stop all running instances
apptainer instance stop --all
```

#### 4. Temporary build files
If an `apptainer build` fails or is interrupted, leftover temporary files might remain in `/tmp` or `$APPTAINER_TMPDIR` (or `$SINGULARITY_TMPDIR`). You can inspect and safely delete temporary directories prefixed with `.singularity.` or `.apptainer.` if they are not in use.

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

## The `--rm` flag

The `--rm` flag tells Docker or Podman to automatically remove the container once it exits:

```bash
docker run --rm tutorial-python-seaborn
```

Without `--rm`, a stopped container stays on disk and accumulates over time. You would need to clean it up manually:

```bash
docker rm <container_id>
```

With `--rm`, the container is deleted immediately after the process inside it finishes — no manual cleanup needed.

When to use it:

- Use `--rm` for one-off tasks: running a script, generating a plot, or any short-lived container
- Skip `--rm` if you need to inspect the container after it exits (e.g., for debugging)
- `--rm` is not compatible with `-d` (detached mode); Docker will ignore it if both are passed together

All `docker run` and `podman run` examples in this README include `--rm` because these containers are meant to be run once and discarded.

## Notes

- Apptainer build may require `sudo` or fakeroot, depending on your setup.
