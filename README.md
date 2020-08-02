# vagrant-ks8-env
Creating a Kubernetes environment using Vagrant along with Virtualbox

<p>This repository provides a template Vagrantfile to create a Kubernetes cluster with a Master Node and N Worker Nodes, using the VirtualBox hypervisor on your local machine.</p>

### <h2>Setup</h2>

### Dependencies
<p>Before running the startup script, it is required that you install, on your local machine, the Vagrant and Virtualbox software. </p>

* [VirtualBox][virtualbox] 4.3.10 or greater.
* [Vagrant][vagrant] 1.6 or greater.


### Cloning the project from Github
```
git clone https://github.com/bmartinezm/vagrant-ks8-env.git
```

### Configuration
The following table lists the configurable parameters of the [Vagrantfile](Vagrantfile) and their default values.

<table>
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
<th>Default</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>centos_release</code></td>
<td>CentOS release</td>
<td><code>7</code></td>
</tr>
<tr>
<td><code>vm_gui</code></td>
<td>If this value is set to true, all CentOS VMs will include the GUI software</td>
<td><code>false</code></td>
</tr>
<tr>
<td><code>vm_size</code></td>
<td>It is the assigned Memory and CPU per instance.Be aware that the minimum memory and CPU per instance is  4096 MB and 2 vcpus</td>
<td><code>{"cpus" => 2, "memory" => 2048}</code></td>
</tr>
<tr>
<td><code>vm_name_mn</code></td>
<td>The Virtual Machine name for the KS8 Master Node in Virtualbox</td>
<td><code>centos-ks8-mnode</code></td>
</tr>
<tr>
<td><code>vm_hostname_mn</code></td>
<td>The server's hostname for the KS8 Master Node</td>
<td><code>ks8-masternode</code></td>
</tr>
<tr>
<td><code>vm_name_wn</code></td>
<td>The Virtual Machine name for the KS8 Worker Nodes in Virtualbox</td>
<td><code>centos-ks8-wnode</code></td>
</tr>
<tr>
<td><code>vm_hostname_wn</code></td>
<td>The servers' hostname for the KS8 Worker Node</td>
<td><code>ks8-workernode</code></td>
</tr>
<tr>
<td><code>N</code></td>
<td>Number of nodes worker nodes, TOTAL VMs: N+1</td>
<td><code>2</code></td>
</tr>
<td><code>vagrant_assets</code></td>
<td>It is the directory where the VMs' bootstrap scripts are stored</td>
<td><code>./vagrant</code></td>
</tr>
<tr>
<td><code>vm_net_mask</code></td>
<td>The environment subnet mask</td>
<td><code>"255.255.255.0"</code></td>
</tr>
<tr>
<td><code>vm_net_ip</code></td>
<td>The KS8 environment's private subnet. Virtualbox's type of network: "host-only"</td>
<td><code>"192.168.100."</code></td>
</tr>
</tbody>
</table>


### Startup 
<p>A Bash script was created to startup easily the Vagrant project. Before running it, make sure that all software and hardware requirements are met.</p>

```
cd vagrant-ks8-env
./startup.sh
```

### <h2>SSH Access</h2>
<p>The startup.sh script triggers the "vagrant up" command to pull the CentOS images (boxes), create the VMs, and download all necessary software to create a Kubernetes cluster. It also creates a ssh key pair to ssh the master and worker nodes. </p>

<h3>Master Node</h3>

```
ssh -i ssh-key vagrant@<vm_net_ip>.10
```
<h3>Worker Nodes</h3>

```
ssh -i ssh-key vagrant@<vm_net_ip>.1N
```

<p>Where N is the number of worker nodes. <b>If you do not change the default network configuration, you could access the servers as follow.</b></p>

<h3>Master node - Defaul net configuration</h3>

```
ssh -i ssh-key vagrant@192.168.100.10
```

<h3>Worker nodes - Defaul net configuration</h3>

```
ssh -i ssh-key vagrant@192.168.100.11
ssh -i ssh-key vagrant@192.168.100.12
ssh -i ssh-key vagrant@192.168.100.1N
```

[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html

<h2>License</h2>

All the code in this repo is under ![picture](https://img.shields.io/badge/license-MIT-brightgreen)

```
MIT License

Copyright (c) 2020
Byron Martinez Martinez bdmartinezm22@gmail.com


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
_2020 - 2020 Bogotá - Colombia_
