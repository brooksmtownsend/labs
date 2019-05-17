#! /bin/sh
# Initial author:  abbottjoel
#
# $Header$

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

PATH=/usr/bin:/bin:/usr/local/bin:/usr/local/go/bin; export PATH
PRG=`basename ${0}`

REGISTRY_DOCKER_HUB="jabbottc1"

APP=hello-go

GOOS=linux
GOARCH=amd64
export GOOS GOARCH

function help() {
	echo "usage:  ${PRG} [-d|--debug] -v|--version sVersion"
}

function fail_trap() {
	result=$?
	if [ "${result}" != "0" ]; then
		echo
		echo "Failed with ${result}"
		exit ${result}
	fi
}
trap "fail_trap" EXIT

if [ $# -eq 0 ]; then
	exit 1
fi

debug=false
version=""
set +o nounset
while [[ $# -gt 0 ]]; do
	case $1 in
		'-d'|'--debug')
			debug=true
			;;
		'-v'|'--version')
			version="$2"
			shift
			;;
		'-h'|'--help')
			help
			exit 0
			;;
		*)
			exit 1
			;;
	esac
	shift
done
set -o nounset

if [ ${debug} = false -a "${version}" = "" ]; then
	help
	exit 1
fi
registry=${REGISTRY_DOCKER_HUB}
docker_file=Dockerfile

go build -ldflags="-s -w" -o ${APP} .
docker build -t ${APP} -f ${docker_file} .
rm ${APP}
if [ ${debug} = true ]; then
        docker run -p 8080:8080 --rm -ti ${APP}
        exit 0
fi
docker tag ${APP} ${registry}/${APP}:${version}
docker push ${registry}/${APP}:${version}

