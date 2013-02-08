#!/bin/bash
cd frontend
dart2js *.dart --minify
cd ..

sudo rsync -rv --copy-links backend/web_root/* /usr/share/nginx/html
rsync -avz backend/db_functions.php /usr/share/nginx/
