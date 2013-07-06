SERVICE='mplayer'

while true; do
  if ps ax | grep -v grep | grep $SERVICE > /dev/null
  then
    echo . > /dev/null #sleep 1;
  else
    mplayer ~/Videos/195-my-favorite-web-apps-in-2009.m4v
  fi
done
