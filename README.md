# meta-etckeeper

OpenEmbedded meta layer for etckeeper. Contains both a recipe for the tools to
be used on target and in sysroot, as well as a rootfs class.

## Usage

Include the layer in your `bbclasses.conf`.

### Creation

Include the rootfs class and image type as in your configuration:

```shell
IMAGE_CLASSES += "etckeeper_rootfs"
IMAGE_FSTYPES += "etckeeper-bare"
```

This will initialize `/etc` on your normal rootfs as a Git repository using etckeeper, and also deploy this as a bare Git repo in your deploy directory.

### Rebasing `/etc`

It is possible to specify a commit as base for your `/etc` repository in the build. This could e.g. be used to release `/etc` repositories which are based on previous releases. Possibly this can then be used to solve configuration conflicts during upgrades, using Git merges or rebases.

List the commit to use as root and the path to the repository containing the commit:

```shell
ETCKEEPER_REBASE_REPO = "file:///path/to/etcrepo.git"
ETCKEEPER_REBASE_REV = "abcdef123456"
```
