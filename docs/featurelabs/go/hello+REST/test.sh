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

echo "Basic test"
set -x
curl -s ${url}
set +x

echo
echo "Show existing entries"
set -x
curl -s ${url}/todos | python -m json.tool
set +x

echo
random_number=${RANDOM}
echo "Insert New entry ${random_number}"
set -x
curl -H "Content-Type: application/json" -d "{\"name\":\"New Todo ${random_number}\"}" ${url}/todos
set +x

echo
random_number=${RANDOM}
echo "Insert New entry ${random_number}"
set -x
curl -H "Content-Type: application/json" -d "{\"name\":\"New Todo ${random_number}\"}" ${url}/todos
set +x

echo
echo "Show all entries"
set -x
curl -s ${url}/todos | python -m json.tool
set +x

number_entries=`curl -s ${url}/todos | python -m json.tool | grep '"id"' | wc -l`
random_entry=`expr ${RANDOM} % ${number_entries} + 1`
random_id=`curl -s ${url}/todos | python -m json.tool | grep '"id"' | head -${random_entry} | tail -1 | sed -e 's/.*"id": //' -e 's/,$//'`
echo
echo "Delete id ${random_id}"
set -x
curl -s -w '%{http_code}' -X DELETE ${url}/todos/{${random_id}}
set +x

echo
echo "Show all entries"
set -x
curl -s ${url}/todos | python -m json.tool
set +x

