## Helm Commands Cheatsheet

### 1. Help, Version

#### See the general help for Helm
```
helm --help
```
#### See help for a particular command
```
helm [command] --help
```
#### See the installed version of Helm
```
helm version
```

### 2. Repo Add, Remove, Update

#### Add a repository from the internet
```
helm repo add [name] [url]
```
#### Remove a repository from your system
```
helm repo remove [name]
```
#### Update repositories
```
helm repo update
```

### 3. Repo List, Search

#### List chart repositories
```
helm repo list
```
#### Search charts for a keyword
```
helm search [keyword]
```
#### Search repositories for a keyword
```
helm search repo [keyword]
```
#### Search Helm Hub
```
helm search hub [keyword]
```

### 4. Install/Uninstall

#### Install an app
```
helm install [name] [chart]
```

#### Install an app in a specific namespace
```
helm install [name] [chart] --namespace [namespace]
```

#### Override the default values with those specified in a file of your choice
```
helm install [name] [chart] --values [yaml-file/url]
```

#### Run a test install to validate and verify the chart
```
helm install [name] --dry-run --debug
```

#### Uninstall a release
```
helm uninstall [release name]
```

### 5. Chart Management

#### Create a directory containing the common chart files and directories
```
helm create [name]
```

#### Package a chart into a chart archive
```
helm package [chart-path]
```

#### Run tests to examine a chart and identify possible issues
```
helm lint [chart]
```

#### Inspect a chart and list its contents
```
helm show all [chart]
```
#### Display the chart’s definition
```
helm show chart [chart]
```

#### Download a chart
```
helm pull [chart]
```

#### Download a chart and extract the archive’s contents into a directory
```
helm pull [chart] --untar --untardir [directory]
```

#### Display a list of a chart’s dependencies
```
helm dependency list [chart]
```

### 6. Release Monitoring

#### List all the available releases in the current namespace
```
helm list
```
#### List all the available releases across all namespaces
```
helm list --all-namespaces
```
#### List all the releases in a specific namespace
```
helm list --namespace [namespace]
```
#### List all the releases in a specific output format
```
helm list --output [format]
```
#### See the status of a release
```
helm status [release]
```
#### See the release history
```
helm history [release]
```
#### See information about the Helm client environment
```
helm env
```

### 7. Upgrade/Rollback

#### Upgrade an app
```
helm upgrade [release] [chart]
```

#### Tell Helm to roll back changes if the upgrade fails
```
helm upgrade [release] [chart] --atomic
```

#### Upgrade a release. If it does not exist on the system, install it
```
helm upgrade [release] [chart] --install
```

#### Upgrade to a version other than the latest one Upgrade an app
```
helm upgrade [release] [chart] --version [version-number]
```

#### Roll back a release
```
helm rollback [release] [revision]
```

### 8. GET Information

#### Download all the release information
```
helm get all [release]
```
#### Download all hooks
```
helm get hooks [release]
```
#### Download the manifest
```
helm get manifest [release]
```
#### Download the notes
```
helm get notes [release]
```
#### Download the values file
```
helm get all [release]
```
#### Release history
```
helm history [release]
```

### 9. Plugin

#### Install plugins
```
helm plugin install [path/url1] [path/url2]
```
#### View a list of all the installed plugins
```
helm plugin list
```
#### Update plugins
```
helm plugin update [plugin1] [plugin2]
```
#### Uninstall a plugin
```
helm plugin uninstall [plugin]
```



