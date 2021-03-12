# Testing

To test the container before publication, run these steps.

1. `container_hash=$(podman build . -q)`.
2. Run: `podman run --privileged --volume ${PWD}/test/:/github/workspace/:z --volume /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:z --tty --interactive --env GITHUB_REPOSITORY="/github/workspace/" ${container_hash}`.
