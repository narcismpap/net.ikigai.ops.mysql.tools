# net.ikigai.ops MySQL Tools
This is a lightweight MySQL 5.6 based service that can help with the archival of legacy 
MySQL-based products. 

It invokes a MySQL 5.6 server and offers an utility toolset for quick management and per-table exports.

### Usage
Operations can be simplified using a custom config file. Simply copy the ./run-example.sh with

```
cp ./run-example.sh run-XXX.sh
nano ./run-XXX.sh
```

Create a local DB secret using:

```
openssl rand -base64 32 > echo > /secrets/db_root.txt
```

Update your local path and then you can simply load up the system using:

```
/bin/bash ./run-XXX.sh up|down|build|(any other docker-compose command)
```

### Errors
If you get the following error during the up command:

```
ERROR: for YYY  Cannot create container for service YYY: invalid mount config for type "bind":
```

It simply means that either the mount volumes or secrets directory is not in your Docker File Sharing settings. See more at [Docker Docs](https://docs.docker.com/docker-for-mac/osxfs/#namespaces).

### Available Tools

```
/bin/bash vadb

1) Shell
2) Backup
3) Quit
```
