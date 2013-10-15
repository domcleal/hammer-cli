Hammer - the CLI tool (not only) for Foreman
============================================


Hammer is a generic [clamp-based](https://github.com/mdub/clamp) CLI framework. 
Hammer-cli provides just the core functionality. The core is extensible with plugins that contain application specific commands.

Such architecture allows for easy customization according to your application setup. Nearly any Ruby script can be turned into a Hammer command so the possibilities are really wide. 

Currently available plugins are:
  - [hammer-cli-foreman](https://github.com/theforeman/hammer-cli-foreman)  - commands corresponding to Foreman API
  - [hammer-cli-katello-bridge](https://github.com/theforeman/hammer-cli-katello-bridge) - set of commands provided by Katello CLI

You also can easily add custom commands specific for your use, such as various bulk actions or admin tasks.


Installation
------------

Hammer CLI is packaged for the following RPM based distributions:

 - RHEL and derivatives, version 6
 - Fedora 18, 19
 - Debian Wheezy, Squeezy
 - Ubuntu Precise

### Installation from RPMs

#### Step 1: setup rpm repositories

For Foreman 1.3 stable the hammer packages are part of your installation repo and you can skip this step.

You can choose from stable or nightly repo. Nightly has more recent version of hammer packages, but it was subject to less testing so there is highr risk of issues.
Add the Foreman rpm repository to your yum repo files. For Fedora installations replace 'el6' with 'f18' or 'f19' as appropriate.

Choose stable

```bash
yum -y install http://yum.theforeman.org/releases/1.3/el6/x86_64/foreman-release.rpm
```

or nightly

```bash
cat > /etc/yum.repos.d/foreman.repo << EOF
[foreman]
name=Foreman Nightly
baseurl=http://yum.theforeman.org/nightly/el6/x86_64
gpgcheck=0
enabled=1
EOF
```

On RHEL systems you will also have to add [EPEL repository](https://fedoraproject.org/wiki/EPEL) as it contains some of the required dependencies.


#### Step 2: install hammer core

```bash
yum install rubygem-hammer_cli
```

#### Step 3: install plugins
Currently, there are two plugins, both available as rpm packages.

 - commands for managing foreman

```bash
yum install rubygem-hammer_cli_foreman
```

 - 1:1 bridge to [katello cli](https://github.com/Katello/katello)

```bash
yum install rubygem-hammer_cli_katello_bridge
```

To install any other hammer plugin just make sure the appropriate gem is installed and follow with the configuration.


### Installation from DEBs

#### Step 1: setup rpm repositories

For Foreman 1.3 stable the hammer packages are part of your installation repo and you can skip this step.

You can choose from stable or nightly repo. Nightly has more recent version of hammer packages, but it was subject to less testing so there is highr risk of issues.

Choose stable (don't forget to replace "squeeze" with version name of your system)

```bash
echo "deb http://deb.theforeman.org/ squeeze stable" > /etc/apt/sources.list.d/foreman.list
```

or nightly

```bash
echo "deb http://deb.theforeman.org/ squeeze nightly" > /etc/apt/sources.list.d/foreman.list
```

and update the keys

```bash
wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
```

#### Step 2: install hammer core

```bash
apt-get update && apt-get install ruby-hammer-cli
```

#### Step 3: install plugins
Currently, there are two plugins, both available as rpm packages.

 - commands for managing foreman

```bash
$ apt-get install ruby-hammer-cli-foreman
```

 - 1:1 bridge to [katello cli](https://github.com/Katello/katello)

```bash
$ apt-get install ruby-hammer-cli-katello-bridge
```

To install any other hammer plugin just make sure the appropriate gem is installed and follow with the configuration.


### Installation from GEMs

Make sure you have ```gem``` command installed on your system

#### Step 1: install hammer core

```bash
$ gem install hammer_cli
```

#### Step 2: install plugins
Currently, there are two plugins, both available on rubygems.org

 - commands for managing foreman

```bash
$ gem install hammer_cli_foreman
```

 - 1:1 bridge to [katello cli](https://github.com/Katello/katello)

```bash
$ gem install hammer_cli_katello_bridge
```

To install any other hammer plugin just install the appropriate gem and follow with the configuration.


### Installation from SOURCE

If you can install hammer from git checkouts, you will need ```rake``` installed on your system.
Clone and install CLI core

```bash
$ git clone git@github.com:theforeman/hammer-cli.git
$ cd hammer-cli
$ rake install
$ cd ..
```

clone plugin with foreman commands

```bash
$ git clone git@github.com:theforeman/hammer-cli-foreman.git
$ cd hammer-cli-foreman
$ rake install
$ cd ..
```

and optionally some other plugins via any of the methods mentioned above.


Configuration
-------------

### Format and locations

Configuration is by default looked for in the following places in that order:

 - ```/etc/foreman/cli_config.yml```.
 - ```~/.foreman/cli_config.yml```
 - ```./config/cli_config.yml``` (config dir in CWD)
 - custom location specified on command line - ```-c CONF_FILE_PATH```

The later has precedence if it redefines the same option.

Hammer uses yaml formating for its configuration. Config file template is contained in the hammer_cli gem

 ```bash
gem contents hammer_cli|grep cli_config.template.yml
```
and can be copied to one of the locations above and changed as needed. The packaged version of hammer copies the template to /etc for you.


### Plugins

Plugins are disabled by default. You have to edit the config file and enable them manually under ```modules``` option, as can be seen in the sample config below.

Plugin specific configuration should be nested under plugin's name.

### Options

 - ```:log_dir: <path>``` - directory where the logs are stored. The default is ```/var/log/foreman/``` and the log file is named ```hammer.log```
 - ```:log_level: <level>``` - logging level. One of ```debug```, ```info```, ```warning```, ```error```, ```fatal```
 - ```:log_owner: <owner>``` - logfile owner
 - ```:log_group: <group>``` - logfile group
 - ```:log_size: 1048576``` - size in bytes, when exceeded the log rotates. Default is 1MB
 - ```:watch_plain: false``` - turn on/off syntax highlighting of data being logged in debug mode

### Sample config

```yaml
:modules:
    - hammer_cli_foreman
    - hammer_cli_katello_bridge

:foreman:
    :host: 'https://localhost/'
    :username: 'admin'
    :password: 'changeme'

:katello_bridge:
    :cli_description: '/home/mbacovsk/work/theforeman/hammer-cli-katello-bridge/katello.json'


:log_dir: '/var/log/foreman/'
:log_level: 'debug'
```

Use the hammer
--------------

Confirm your setup by running ```$ hammer -h``` and see if the desired commands are listed.


And you are Done. Your hammer client is configured and ready to use.


Autocompletion
--------------

It is necessary to copy script hammer_cli_complete to the bash_completion.d directory.

    $ sudo cp hammer-cli/hammer_cli_complete /etc/bash_completion.d/

Then in a new shell the completion should work.


License
-------

This project is licensed under the GPLv3+.


Acknowledgements
----------------

Thanks to Brian Gupta for the initial work and a great name.
