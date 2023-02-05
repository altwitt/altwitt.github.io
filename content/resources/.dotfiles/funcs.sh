# Switch long/short prompt

ps0() {
  unset PROMPT_COMMAND
  PS1='$ '
}

ps1() {
  source "$DOTFILES_DIR"/system/.prompt
}

# Get named var (usage: get "VAR_NAME")

get() {
  echo "${!1}"
}

# Add to path

prepend-path() {
  [ -d $1 ] && PATH="$1:$PATH"
}

# Show 256 TERM colors

colors() {
  local X=$(tput op)
  local Y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}; do
  o=00$i;
  echo -e ${o:${#o}-3:3} $(tput setaf $i;tput setab $i)${Y// /=}$X;
  done
}

# Calculator

calc() {
  echo "$*" | bc -l;
}

# Weather

meteo() {
  local LOCALE=$(echo ${LANG:-en} | cut -c1-2)
  if [ $# -eq 0 ]; then
    local LOCATION=$(curl -s ipinfo.io/loc)
  else
    local LOCATION=$1
  fi
  curl -s "$LOCALE.wttr.in/$LOCATION"
}

# Markdown

md() {
  pandoc $1 | lynx -stdin -dump
}

# Change working directory to the top-most Finder window location

function cdf() {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Dev

d() {
  $DOTFILES_IDE ${1:-.}
  $DOTFILES_GIT_GUI ${1:-.}
}

# Open query in Dash app

dash() {
  case $# in
    1) QUERY="$1";;
    2) QUERY="$1:$2";;
    *) echo "Usage: dash [docset] query"; return 1;
  esac
  open "dash://$QUERY"
}

# Open man page as PDF

manpdf() {
  man -t "$1" | open -f -a /Applications/Preview.app/
}

# Create a new directory and enter it

mk() {
  mkdir -p "$@" && cd "$@"
}

# Fuzzy find file/dir

ff() { find . -type f -iname "*$1*";}
fd() { find . -type d -iname "*$1*";}


# Show disk usage of current folder, or list with depth

duf() {
  du --max-depth=${1:-0} -c | sort -r -n | awk '{split("K M G",v); s=1; while($1>1024){$1/=1024; s++} print int($1)v[s]"\t"$2}'
}

# Check if resource is served compressed

check_compression() {
  curl --write-out 'Size (uncompressed) = %{size_download}\n' --silent --output /dev/null $1
  curl --header 'Accept-Encoding: gzip,deflate,compress' --write-out 'Size (compressed) =   %{size_download}\n' --silent --output /dev/null $1
  curl --head --header 'Accept-Encoding: gzip,deflate' --silent $1 | grep -i "cache\|content\|vary\|expires"
}

# Get gzipped file size

gz() {
  local ORIGSIZE=$(wc -c < "$1")
  local GZIPSIZE=$(gzip -c "$1" | wc -c)
  local RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
  local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
  printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
}

# Create a data URL from a file

dataurl() {
  local MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
  if [[ $MIMETYPE == "text/*" ]]; then
    MIMETYPE="${MIMETYPE};charset=utf-8"
  fi
  echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

