#!/bin/bash - 
#===============================================================================
#
#          FILE: ip_detect.sh
# 
#         USAGE: ./ip_detect.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Peter McConnell (me@petermcconnell.com), 
#  ORGANIZATION: 
#       CREATED: 14/07/2017 21:03
#      REVISION:  ---
#===============================================================================


set -o nounset -o errexit -o pipefail
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:$PATH
MASTER_IP=$(dig +short master.mesos || true)
MASTER_IP=${MASTER_IP:-${master_ip}}
INTERFACE_IP=$(ip r g ${MASTER_IP} | \
awk -v master_ip=${MASTER_IP} '
BEGIN { ec = 1 }
{
  if($1 == master_ip) {
    print $7
    ec = 0
  } else if($1 == "local") {
    print $6
    ec = 0
  }
  if (ec == 0) exit;
}
END { exit ec }
')
echo $INTERFACE_IP

