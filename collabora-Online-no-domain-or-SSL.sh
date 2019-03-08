docker run -t -d -p 9980:9980 --name collabora_nextcloud --restart always --cap-add MKNOD collabora/code

docker exec -it collabora_nextcloud /bin/bash -c "apt-get -y update && apt-get -y install xmlstarlet && xmlstarlet ed --inplace -u \"/config/ssl/enable\" -v false /etc/loolwsd/loolwsd.xml && xmlstarlet ed --inplace -u \"/config/ssl/termination\" -v false /etc/loolwsd/loolwsd.xml"

docker restart collabora_nextcloud
