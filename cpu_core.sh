#!/bin/sh
if [ ! -r /proc/cpuinfo ]; then
  echo "Is this Linux? Cannot find or read /proc/cpuinfo"
  exit 1
fi
echo num_cpus = `grep 'physical id' /proc/cpuinfo | sort -u | wc -l`
read num_cpu
echo num_cores_per_cpu=`grep 'core id' /proc/cpuinfo | sort -u | wc -l`
read num_cores_per_cpu
echo total_cores=`expr $num_cpus \\* num_cores_per_cpu` --this part is not working..

if [ $num_cores -eq 0 ]; then
# this box is either an old SMP or single-CPU box, so count the # of processors

  echo num_cores=`grep '^processor' /proc/cpuinfo | sort -u | wc -l`

fi
#echo $num_cores_per_cpu
