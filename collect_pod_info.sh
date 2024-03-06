#!/bin/bash 
# This is script gathers pod information and logs from any kubernetes cluster for analysis and troubleshooting purposes. Author Marc Lehmberg marc.lehmberg@suse.com

(
tmp_dir=/tmp/supportlogs
tmp_file=$tmp_dir/pod_logs.txt
NOW=`date '+%F_%H:%M:%S'`
function get_pods () {
	kubectl get pods -A -o wide > $/tmp_dir/pod_info.txt
	kubectl get pods -A  | grep -v NAMESPACE | tr -s '[:space:]' | cut -d " " -f 1,2 >$tmp_file
}


#read describe pods in cluster and get logs
function get_pod_info () {
while read p; do

	tmp_namespace=`echo "$p" | cut -d " " -f 1`
	tmp_pod=`echo "$p" | cut -d " " -f 2`
	echo "Gathering logs for $tmp_pod in $tmp_namespace"
	cd $tmp_dir
	mkdir $tmp_pod
	cd $tmp_pod
	describe_filename="$tmp_namepace_$tmp_pod_$NOW_describe.txt"
	log_filename="$tmp_namepace_$tmp_pod_$NOW_log.txt"
	kubectl describe pod $tmp_pod -n $tmp_namespace > describe.log
	kubectl logs $tmp_pod -n $tmp_namespace > log.log
done < $tmp_file
}

function cleanup () { #cleanup
sudo rm -rf $tmp_dir
}

function prepare_tmp () {
mkdir $tmp_dir
}

function system_log (){
echo "Copying system logs" 
cd $tmp_dir 
mkdir system_logs 
cd system_logs 
echo "Provide superuser(root) password to copy system logs"
sudo cp /var/log/messages* .
sudo cp -r /var/log/pods .
cp /tmp/colllect_pod_info.log .
}

function compress_files () {
cd /tmp 
sudo tar -zcf supportlogs_`echo $HOSTNAME`_`date '+%Y_%m_%d__%H_%M_%S'`.tar.gz $tmp_dir /tmp/collect_pod_info.log
echo""
echo "Please send /tmp/supportlogs_`echo $HOSTNAME`_`date '+%Y_%m_%d__%H_%M_%S'`.tar.gz to the support team for analysis"

}


#start main 

prepare_tmp
get_pods
get_pod_info
system_log
compress_files 
cleanup

#end main 
) 2>&1 | tee /tmp/collect_pod_info.log
