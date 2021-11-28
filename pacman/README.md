https://ownyourbits.com/2017/09/04/save-and-restore-your-arch-linux-packages/

### Create a package list
The following command creates a list with your packages, that you can curate and store under private versioning control.

- `pacman -Qqen > pkglist.txt`

And this will create a list with the packages that were installed external to the pacman database, either manually installed or from the AUR.

- `pacman -Qqem > localpkglist.txt`

Now make it a cronjob script that runs on boot and keeps a log in

~/logs/pacman/package-list-%date%.log
