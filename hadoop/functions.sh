#!/bin/bash

apache_mirror() {
    BASE_URI=$(curl -L http://www.apache.org/dyn/closer.cgi$1\?asjson\=1 | grep -Eo '"preferred":.*?".*?[^\\]"' | cut -d ' ' -f 2 | sed 's/"//g')
    echo $BASE_URI$1
}

# Attempt to download Apache project from mirror, otherwise fallback to Apache archive. places 
# downloaded file in the `/tmp` directory
#
# Arguments:
#   URL path to project archive
apache_dl() {
    DL_URL=$(apache_mirror $1)
    APACHE_FN=$(basename $1)
    curl -fSL $DL_URL -o /tmp/$APACHE_FN
    if [ $? != 0 ]; then
        # Not in mirror, download from archive
        curl -fSL "https://archive.apache.org/dist/$1" -o /tmp/$APACHE_FN
        SIG_URL=https://archive.apache.org/dist/$1.asc
    else
        # Downloaded from mirror, grab keys from release repo
        SIG_URL=https://dist.apache.org/repos/dist/release/$1.asc
    fi
    curl -fSL "$SIG_URL" -o /tmp/$APACHE_FN.asc
    echo "/tmp/$APACHE_FN"
}

# Verifies Apache signature using package keys
#
# Arguments:
#   Path to package to verify, signature should be in same path with .asc appended to name
#   URL path to KEYS file for Apache project
apache_verify() {
    curl -fSL https://dist.apache.org/repos/dist/release/$2 -o /tmp/KEYS
    gpg --no-default-keyring --keyring /tmp/keys.gpg --import /tmp/KEYS
    if gpgv --keyring /tmp/keys.gpg $1.asc $1; then
        rm -rf /tmp/keys.gpg* /tmp/KEYS
        return 0
    else
        echo "Validation of signature failed for $1"
        return 1
    fi
}

# Downloads and installs Apache project in `/opt` directory.
#
# Arguments:
#   URL path to Apache project archive to download
#   URL path to KEYS file for Apache project
apache_install() {
    APACHE_FN=$(apache_dl $1)
    if apache_verify $APACHE_FN $2; then
        tar -xf $APACHE_FN -C /opt/
        rm -rf $APACHE_FN*
        return 0
    else
        echo "Install failed: $1"
        return 1
    fi
}

addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

configureHostResolver() {
    sed -i "/hosts:/ s/.*/hosts: $*/" /etc/nsswitch.conf
}
