# Helm completion2and3 plugin

This plugin allows shell completion to work for both Helm v2 and Helm v3
at the same time.  It targets users that need to run both Helm versions while transitioning from v2 to v3.

## Installation

This plugin works with either Helm v2 or Helm v3. You can install it in which ever version you prefer.
I recommend installing it with v2 since once your v2 to v3 migration is finished, you will not need this plugin anymore.

```
helm plugin install https://github.com/marckhouzam/helm-completion2and3
```

## Usage

The plugin will generate an autocompletions script that will work for
both helm2 and helm3 together.  That script must be sourced in the bash
or zsh shells you will use with helm.

To generate the script that must be sourced:
```
$ helm completion2and3 <bash|zsh> <helm2> <helm3>
```
where `helm2` is the way you use to invoke Helm v2
and `helm3` is the way you use to invoke Helm v3.
Both `helm2` and `helm3` must either be found on $PATH or must
be aliases referring to the correct binaries.

For example if you have binaries such that:
```
$ helm version -c
Client: &version.Version{SemVer:"v2.16.0-rc.2", GitCommit:"e13bc94621d4ef666270cfbe734aaabf342a49bb", GitTreeState:"clean"}

$ helm3 version
version.BuildInfo{Version:"v3.0.0-rc.1", GitCommit:"ee77ae3d40fd599445ebd99b8fc04e2c86ca366c", GitTreeState:"clean", GoVersion:"go1.13.3"}
```
You can then do:
```
$ source <(helm completion2and3 bash helm helm3)
```

### Bash 3

Bash 3, which is the version on MacOS, does not support sourcing a file using `<()`.
Instead, you can do:
```
$ helm completion2and3 bash helm helm3 > comp.sh
$ source comp.sh
$ rm comp.sh
```
