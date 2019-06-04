#!/bin/bash

# List directory bookmarks in Emacs

# Integration example:
# cd `lsbm.d | fzy -p 'cd to bookmark: '`

IFS=:
for dir in $(emacsclient --eval "(->> (progn
       (bookmark-maybe-load-default-file)
       bookmark-alist)
     (-map #'bookmark-get-filename)
     (-filter (-partial #'string-suffix-p \"/\"))
     (-map #'expand-file-name)
     (-sort #'string<)
     (funcall (-flip #'string-join) \":\"))" \
         | sed -e 's/^"//' -e 's/"$//'); do
    echo $dir
done
