#!/bin/sh

OM_VERSION="0.27.0"
PKS_TILE_ENDPOINT="http://pa-dbc1123.eng.vmware.com/lzhan/pks-tile/p-pks-1.10.0-build.17.pivotal"
STEMCELL_ENDPOINT="https://s3.amazonaws.com/bosh-core-stemcells/vsphere/bosh-stemcell-3445.16-vsphere-esxi-ubuntu-trusty-go_agent.tgz"

stemcell="stemcell.tgz"
pkstile="pks.tile"

echo "downloading pks-tile"
curl -o ${pkstile} ${PKS_TILE_ENDPOINT}

echo "downloading stemcell"
curl -o ${stemcell} ${STEMCELL_ENDPOINT}

echo "downloading om(version:${OM_VERSION})"
curl -o om -L https://github.com/pivotal-cf/om/releases/download/${OM_VERSION}/om-linux

sudo chmod +x om
sudo mv om /usr/local/bin

echo "Type in your ops manager IP"
read OPS_MANAGER_IP
echo "Type in your ops manager username"
read OPS_MANAGER_USERNAME
echo "Type in your ops manager password"
read OPS_MANAGER_PASSWORD

if [ ! -f ${pkstile} ]; then
    echo "error: ${pkstile} is not found"
else
    echo "uploading ${pkstile}"
    om -t $OPS_MANAGER_IP -u $OPS_MANAGER_USERNAME -p OPS_MANAGER_PASSWORD --skip-ssl-validation upload-product -p ${pkstile}
fi

if [ ! -f ${stemcell} ]; then
    echo "error: ${stemcell} is not found"
else
    echo "uploading ${stemcell}"
    om -t $OPS_MANAGER_IP -u $OPS_MANAGER_USERNAME -p OPS_MANAGER_PASSWORD --skip-ssl-validation upload-stemcell -s ${pkstile}
fi

echo "Do you want to remove downloaded artifacts[yes/no]"
read -n 1 remove
if [ ${remove} == "y" ]; then
  echo "removing ${pkstile} ${stemcell}"
  rm ${pkstile} ${stemcell}
elif [ ${remove} == "n" ]; then
  echo "skipping deletion of artifacts: ${pkstile},${stemcell}"
else
  echo "error: ${remove} is not recognized"
fi
