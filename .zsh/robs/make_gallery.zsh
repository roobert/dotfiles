function make_gallery {
  if [ -f 'index.html' ]; then rm index.html; fi

  for i in *; do
    echo "<a href="$i"><img src='$i' /></a>" >> index.html
  done

  echo "<style>img { height: 300px; margin: 3px; }</style>" >> index.html
}
