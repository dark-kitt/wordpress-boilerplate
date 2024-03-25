#!/bin/sh
# merge scripts/* into composer.json
MERGE_REQUIRED=false
for file_path in $(git diff --cached --name-only)
do
  if [[ $file_path == *"scripts/"* ]]; then
    MERGE_REQUIRED=true
  fi
done

if [[ $MERGE_REQUIRED == true ]]; then
  echo "read ./scripts directory ..."
  # ignore system and other files
  ignore=("." ".." "read-write-files.sh")

  for file_name in $(cd ./scripts && ls -a)
  do
    if [[ ! ${ignore[@]} =~ $file_name ]]; then
      echo "merge file into composer.json: $file_name"

      FILE_CONTENT=''
      while IFS= read -r line; do
        # escape chars
        result="${line//\\/\\\\}"
        result="${result//\"/\\\"}"
        # create file string
        if [[ $1 != .htaccess ]]; then
          FILE_CONTENT="$FILE_CONTENT$result\n"
        else
          FILE_CONTENT="$FILE_CONTENT$line\n"
        fi
      done < ./scripts/$file_name

      COMPOSER_CONTENT=''
      while IFS= read -r line; do
        # replace \n and \t for placeholder
        result="${line//\\n/X_NEW_LINE}"
        result="${result//\\t/X_NEW_TAB}"
        result="${result//\\/\\\\}"

        condition=$(echo $result | tr -s '[:blank:]')
        if [[ ($condition = "\"chmod +x"* || $condition = "\"echo '"*) && $condition = *"$file_name;\"" ]]; then
          # reformat content
          content="${FILE_CONTENT//\\n/X_NEW_LINE}"
          content="${content//\\t/X_NEW_TAB}"
          content="${content//\\/\\\\}"
          # TODO: get space from result string
          if [[ $file_name != ".env" ]]; then
            COMPOSER_CONTENT="$COMPOSER_CONTENT      \"echo '$content' > ./web/$file_name;\"\n"
          else
            if [[ $file_name == ".env" ]]; then
              # ENV variables
              COMPOSER_CONTENT="$COMPOSER_CONTENT      \"echo '$content' > $file_name;"
              # tocken cmd
              COMPOSER_CONTENT="$COMPOSER_CONTENT curl -s https://api.wordpress.org/secret-key/1.1/salt | sed \\\"s/^define('X_ESCAPEX_ESCAPE(.*X_ESCAPEX_ESCAPE)',X_ESCAPEX_ESCAPE *'X_ESCAPEX_ESCAPE(.*X_ESCAPEX_ESCAPE)');$/X_ESCAPEX_ESCAPE1='X_ESCAPEX_ESCAPE2'/g\\\" >> .env;"
              # API auth
              COMPOSER_CONTENT="$COMPOSER_CONTENT echo 'X_NEW_LINEJWT_AUTH_SECRET_KEY=\\\"'\$(openssl rand -base64 48)'\\\"X_NEW_LINEJWT_AUTH_CORS_ENABLE=false' >> .env;\"\n"
            fi
          fi
        else
          COMPOSER_CONTENT="$COMPOSER_CONTENT$result\n"
        fi
      done < composer.json
      # print each line into the file again
      echo "$COMPOSER_CONTENT" > composer.json
    fi
  done

  # prettify file
  # remove empty lines
  sed -i '' -r '/^\s*$/d' composer.json
  # replace placeholder
  sed -i '' -e 's/\t/X_NEW_TAB/g' composer.json
  sed -i '' -e 's/X_NEW_LINE/\\n/g' composer.json
  sed -i '' -e 's/X_NEW_TAB/\\t/g' composer.json
  sed -i '' -e 's/X_ESCAPE/\\/g' composer.json
  # add composer.json to commit
  git add composer.json
  #! NOTE: $(git commit) is not working while merging branches
  # git commit -F composer.json -m "fix(composer): ~ script/s were updated"

  echo "done."
fi
exit 0