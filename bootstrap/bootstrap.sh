#!/bin/bash

# Set hostname to puppet to make lab easier
echo "Setting hostname..."
/usr/bin/sed -i 's/localhost.localdomain/puppet/g' /etc/hostname
/usr/bin/sed -i 's/localhost /puppet localhost /g' /etc/hosts
/usr/bin/sed -i 's/search localdomain/#search localdomain/g' /etc/resolv.conf
/usr/bin/hostname -F /etc/hostname

echo "Downloading Puppet Enterprise..."
/usr/bin/curl -O https://s3.amazonaws.com/pe-builds/released/2019.1.0/puppet-enterprise-2019.1.0-el-7-x86_64.tar.gz

echo "Extracting Puppet Enterprise..."
/usr/bin/tar -xvf puppet-enterprise-2019.1.0-el-7-x86_64.tar.gz

echo "Installing Puppet Enterprise..."
./puppet-enterprise-2019.1.0-el-7-x86_64/puppet-enterprise-installer -c demo-pe.conf

# Puppet Enterprise installation is completed by subsequent agent runs
echo "Running puppet..."
/usr/local/bin/puppet agent -t
echo "Running puppet again..."
/usr/local/bin/puppet agent -t

echo "Prevent puppet agent from automatically running..."
/usr/local/bin/puppet config set runinterval 1y

echo "Installing modules from Puppetfile"
/opt/puppetlabs/puppet/bin/r10k puppetfile install Puppetfile -v --moduledir /etc/puppetlabs/code/environments/production/modules

echo "Use puppet apply for further bootstrap..."
/usr/local/bin/puppet apply devnet.pp

# sync up all the new modules and configure puppet device
echo "Running puppet again..."
/usr/local/bin/puppet agent -t

# Autosign should take care of this - if not check the console
echo "Adding CSR1kv to Puppet"
/usr/local/bin/puppet device -w 5

# Configure Bolt
echo "Executing Bolt to build dir structure"
/usr/local/bin/bolt puppetfile show-modules

echo "Use puppet apply to install Bolt modules..."
/usr/local/bin/puppet apply bolt/bolt.pp

echo "Installing Bolt modules"
/usr/local/bin/bolt puppetfile install

echo "Installing Bolt gems"
/opt/puppetlabs/bolt/bin/gem install net-ssh-telnet

echo "Bootstrapping complete."