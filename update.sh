trap __EXIT EXIT
  
function __EXIT() {
    bash /3rd/update.sh &
}


timeout 2m git pull > tmp

if [ $(cat tmp | grep -v 'Already up-to-date' | wc -l) -eq 0 ]; then
    echo 'none'
else
	openresty -s reload
fi

sleep 10

