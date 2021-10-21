#!/bin/bash

docker run -d --network host --rm  -v /images:/var/www/html/images -v /home/vagrant/LocalSettings.php:/var/www/html/LocalSettings.php mediawiki
# docker run -d --network host --rm  -v /home/vagrant/LocalSettings.php:/var/www/html/LocalSettings.php mediawiki
