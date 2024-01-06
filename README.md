# kubernetes-bricksandblocks

Deployments for Kubernetes at bricksandblocks.net

# Requirements

* [git](http://git-scm.com)
* [rclone](https://rclone.org)
* [Task](https://taskfile.dev)

# Configuration

* Make a copy of `env.dist` called `.env`
* Fill in appropriate values for `.env`
* Add submodule for taskfiles and run setup task

```
git submodule add https://github.com/frozenfoxx/taskfiles.git .taskfiles
task setup
```

# Usage

## Deploy All

To deploy all manifests run:

```
task deploy
```

# Contribution

Pull requests welcome.
