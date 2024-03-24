#!/usr/bin/env bash
FILE_CONTENT=''
while IFS= read -r line; do
  # escape chars
  # result="${line//%/\%}"
  result="${line//\\/\\\\}"
  result="${result//\"/\\\"}"
  echo $result
  # create file string
  if [[ $1 != .htaccess ]]; then
    FILE_CONTENT="$FILE_CONTENT$result\n"
  else
    FILE_CONTENT="$FILE_CONTENT$line\n"
  fi
done < ./scripts/$1

# render escaped chars
if [[ $1 != .htaccess ]]; then
  printf "$FILE_CONTENT" > $2
else
  echo -e "$FILE_CONTENT" > $2
fi
# don't render escaped chars
# echo "$FILE_CONTENT" > $2

if [[ $1 == .env ]]; then
  salt=$(curl -s https://api.wordpress.org/secret-key/1.1/salt | sed "s/^define('\\(.*\\)',\\ *'\\(.*\\)');$/\\1='\\2'/g")
  token='\n\nJWT_AUTH_SECRET_KEY="'$(openssl rand -base64 48)'"\nJWT_AUTH_CORS_ENABLE=false'
  echo -e "\n$salt$token" >> $1
fi
