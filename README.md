# nixos-config
In this repo is saved my NixOS configuration, every machine has its own branch.
Clone this repo in the .dotfile folder in your home, switch the branch and run

``` bash
$ sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
$ sudo nix-channel --update
$ sudo nixos-rebuild switch -I nixos-config=.dotfile/nixos-config/configuration.nix
```
