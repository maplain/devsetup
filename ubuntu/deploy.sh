#!/bin/bash

docker run -d --network host --rm  -v /home/vagrant/LocalSettings.php:/var/www/html/LocalSettings.php mediawiki
