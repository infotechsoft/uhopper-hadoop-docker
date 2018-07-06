#!/bin/bash

apache_mirror() {
    BASE_URI=$(curl -L http://www.apache.org/dyn/closer.cgi$1\?asjson\=1 | grep -Eo '"preferred":.*?".*?[^\\]"' | cut -d ' ' -f 2 | sed 's/"//g')
    echo $BASE_URI$1
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
