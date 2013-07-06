SERVICE='omxplayer'

while true; do
  if ps ax | grep -v grep | grep $SERVICE > /dev/null
  then
    echo . > /dev/null #sleep 1;
  else
    omxplayer --align center --adev hdmi $1
  fi
done
