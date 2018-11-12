#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Installs the Slurm Workload Manager (WLM) on Ubuntu
# https://slurm.schedmd.com/
apt-get update

# Try the Lawrence Livermore National Laboratory (LLNL) version first
apt-get install -y slurm-llnl || apt-get install -y slurm-wlm

# Create various directories used by slurm
mkdir -p /etc/slurm-llnl
mkdir -p /var/run/slurm-llnl
mkdir -p /var/run/munge
mkdir -p /var/spool/slurmd

# A mash of configure-until-it-runs. Feel free to PR suggestions/fixes
# https://slurm.schedmd.com/tutorials.html
# https://slurm.schedmd.com/configurator.html
# https://slurm.schedmd.com/slurm.conf.html
# https://slurm.schedmd.com/quickstart_admin.html
cat <<SLURM_CONF > /etc/slurm-llnl/slurm.conf
ControlMachine=localhost
NodeName=localhost
PartitionName=localpartition Nodes=localhost Default=YES
ProctrackType=proctrack/pgid
ReturnToService=1
SelectType=select/cons_res
SelectTypeParameters=CR_CPU
SlurmctldDebug=3
SLURM_CONF

# Munge will run as the munge user, so change the owner of the directory
chown munge:munge /var/run/munge

# Create a munge key, required for slurm-llnl
dd if=/dev/random bs=1 count=1024 >/etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key

# Start munge as the munge user
sudo -u munge munged

# Start the slurm master
slurmctld

# Start the slurm node
slurmd
