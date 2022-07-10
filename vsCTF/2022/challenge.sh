#/usr/bin/env bash

name=$(echo $1 | tr ' ' '_')
mkdir -p $name/images
mkdir -p $name/attachments

mv ~/Downloads/Screenshot* $name/images/prompt.png

cat << EOF > $name/readme.md
# $1

### Prompt
![Prompt](images/prompt.png)

### Solution

**Flag**:
EOF

