# Run

`install.sh` use `apt install` and `npm install --global` commands. To run properly this script, execute command with sudo.
Sudo should contains PATHs of current user (e.i. in order to find `go` or `cargo` binaries):

```
sudo -E env "PATH=$PATH" ./install.sh <ARG>
```
