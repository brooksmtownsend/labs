if [ "$1" = "" ]; then
	url=http://localhost:8080
else
	echo $1 | grep -q ://
	if [ $? -eq 0 ]; then
		url=$1
	else
		url=https://$1
	fi
fi


echo "Basic test"
set -x
curl -s ${url}
echo
set +x

