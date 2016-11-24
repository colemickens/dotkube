# polykube

## Overview

This repositor is an example of a "full stack application" ready to be deployed into a Kubernetes cluster.

The README walks through deployment of:

  * a [Kubernetes]() cluster on the [Azure Container Service]()
  * a private Docker registry hosted by [Azure Container Registry]()

Next, the service's components are deployed on the Kubernetes cluster:

  * an [AspNetCore]() application powered by [.NET Core]()
  * a [Redis]() instance, used as a cache in the AspNetCore application
  * a [SQL Server for Linux]() instance, used a the persistent store for the AspNetCore application

Some other features of note (largely just features of Kubernetes):

  * SQL Server's data is stored in stored in an Azure VHD, via [Dynamic Disk Provisioning functionality in Kubernetes]().
  * The application will be automatically exposed to the public Internet via an Azure Load Balancer, all completely automatically.
  * Rolling updates to an entire cluster with a single command and a matter of seconds (or minutes depending on how many instances)

## Demo

~~The application is running at [polykube.io](https://polykube.io) and [api.polykube.io](https://api.polykube.io/counter).~~

## Prerequisites

1. `make`
2. `docker` (only tested on Linux)
3. `kubectl` (must be pointed at a healthy Kubernetes cluster) (linux: amd64) (darwin: amd64) (windows: amd64)
5. `cfcli` (optional, used for full DNS/SSL automation) (`npm install -g cfcli`)

## Layout

Each component has, where applicable:
- a `make dev` command to enter a development environment ready to immediately build/run/test
- a `make dbuild` command to build using a container
- a `make container` command to build the "production" container that will be deploy
- a `make push` command to push the image to the registry, specified by `$REGISTRY`

## Deployment

This will build, push, and deploy everything. (And it's idempotent):

```shell
make magic
```

I recommend you explore the rabbit hole of Makefiles. It helps explain how pieces fit together.

## TODO
  0. Finish the frontend. (Angular2)
  1. move dotnet dns hack out of kube deploy files and into C#


---

# OLD README

---

## Features
  0. **Docker:** Minimal production containers including only the application (no source code, no build tools, etc)

  1. **Kubernetes:** Fast, reliable and repeatable deployments using Kubernetes Deployments, Services, DaemonSets and Secrets.

  3. **.NET Core:** Example AspNetCore API web application.

  4. **Angular2:**  Example `angular2-material` frontend Typescript application

## Goals

  1. Provide an example of how to use Docker for local development. This repo shows how you can use docker to have a full development environment that only relies on `make` and `docker` being available.

  2. Provide an example of how to build Docker containers meant for production.

  2. Provide an example of using Kubernetes for production container management,


## Motivations

  1. Encourage Docker adoption, even for software that doesn't need to be run with Docker. The fact that anyone can install `git`, `make`, `docker`, and clone my repository and instantly have a working development environment is a big deal. I can't imagine the number of projects that I've fiddled with for hours before abandoning because I couldn't get the right version of `node`/`npn`/dependenics and the application code to get along together. These issues largely disappear if there is a `Dockerfile` that defines the development environment for the project.

  2. Encourage better Docker practices. Your production service doesn't need a compiler. Your production service doesn't need a copy of your application source code. So why ship them and their bloat to your production environment? This repo includes an example of how one can have separate `build` and `runtime` containers so that you can ship only your final binary bits (and their dependencies) to prodction.

  3. Encourage Kubernetes adoption. I continue to see people who think they don't need the "complexity" of Kubernetes, and then wind up re-inventing the so-called complexity via bash scripts that are subject to less design and review than the Kubernetes project. Hopefully this repo can demonstrate the few yaml files needed to make a project deployable into Kubernetes.


## Kubernetes features

0. Basics

   Uses Deployments and Services to abstract and manage your actual application.

1. Secrets

   Uses Secrets to provide database and redis passwords at runtime. This eliminates the need for application secrets to ever live in the application source code repository.

2. Service Discovery

   Uses the Cluster DNS addon to resolve services at runtime in cluster.
   (The dotnet api simply connects to postgres via `tcp://db:5432`, redis via `tcp://redis:6379`, etc.)
