# Helm completion2and3 plugin

This plugin allows shell completion to work for both Helm v2 and Helm v3
at the same time.  It targets users that need to run both Helm versions while transition from v2 to v3.

## Installation

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
where `helm2` is the binary name you use to invoke Helm v2
and `helm3` is the binary name you use to invoke Helm v3.
Both `helm2` and `helm3` must be found on $PATH.

For example:
```
$ source <(helm completion2and3 bash helm helm3)

$ helm version -c
Client: &version.Version{SemVer:"v2.16.0-rc.2", GitCommit:"e13bc94621d4ef666270cfbe734aaabf342a49bb", GitTreeState:"clean"}

$ helm3 version
version.BuildInfo{Version:"v3.0.0-rc.1", GitCommit:"ee77ae3d40fd599445ebd99b8fc04e2c86ca366c", GitTreeState:"clean", GoVersion:"go1.13.3"}
```

### Bash 3

Bash 3, which is the version on MacOS, does not support sourcing a file using `<()`.
Instead, you can do:
```
$ helm completion2and3 bash helm helm3 > comp.sh
$ source comp.sh
$ rm comp.sh