# Hive SDK Docs using [Slate](https://lord.github.io/slate/#introduction)

## Getting Started

The docs are in [`source/index.html.md`](source/index.html.md). To preview
them, run this with Docker or Podman:

```sh
docker compose up -d
```

Then open http://localhost:4567, and reload the page to see your edits. Stop
it with `docker compose down`.

Docker is the only supported way to build the site. The preview and the
deployed image both use the Ruby and gems in the same pinned
`slatedocs/slate` image, so there's no Ruby to install.

## Deployment

sdk.hive.co runs in Hive's Kubernetes cluster, from a container image that
[this repo's workflow](.github/workflows/build-image.yml) builds (see the
[Dockerfile](Dockerfile)). Deploying takes two PRs and no server access.

1. **Open a PR here.** The workflow builds the site and checks the image. To
   preview your change, run `docker compose up -d`; it uses the same Slate
   image and config as the build.
2. **Merge to `master`.** The workflow pushes
   `400748478358.dkr.ecr.us-east-1.amazonaws.com/sdk-docs-ecr-use1:<commit SHA>`,
   and the run's summary shows the full tag.
3. **Open a PR in [HiveHQ/aws-infra](https://github.com/HiveHQ/aws-infra)**
   that sets `newTag` in
   [`kubernetes/apps/base/sdk-docs/kustomization.yaml`](https://github.com/HiveHQ/aws-infra/blob/main/kubernetes/apps/base/sdk-docs/kustomization.yaml)
   to that commit SHA. A Reliability Pod member approves it, and once it
   merges, Flux rolls out the new pods.

Merging here on its own doesn't change sdk.hive.co. To roll back, revert the
aws-infra PR. The aws-infra side, including how to compare an image with the
live site before you deploy it, is in
[`kubernetes/apps/base/sdk-docs/README.md`](https://github.com/HiveHQ/aws-infra/blob/main/kubernetes/apps/base/sdk-docs/README.md).
