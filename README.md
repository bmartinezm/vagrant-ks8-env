# vagrant-ks8-env
Creating a Kubernetes environment using Vagrant along with Virtualbox

<p>This repository provides a template Vagrantfile to create a Kubernetes cluster with a Master Node and N Worker Nodes, using the VirtualBox hypervisor on your local machine.</p>

### <h2> Setup</h2>
<h2> ### Setup</h2>

### Dependencies
<p>Before running the startup script, it is required that you install, locally in your machine, the Vagrant, and Virtualbox software. </p>

* [VirtualBox][virtualbox] 4.3.10 or greater.
* [Vagrant][vagrant] 1.6 or greater.




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
<td><code>STACK_NAME</code></td>
<td>Nombre para los stacks creados cloudformation</td>
<td><code>ModVal-Stack</code></td>
</tr>
<tr>
<td><code>AWS_PROFILE</code></td>
<td>Nombre del perfil configurado en AWS credentials</td>
<td><code>""</code></td>
</tr>
<tr>
<td><code>AWS_REGION</code></td>
<td>Región donde se creará el cluster EKS y sus componentes</td>
<td><code>us-east-1</code></td>
</tr>
<tr>
<td><code>VPC_STACK_TEMPLATE</code></td>
<td>Template para creación de la VPC con subnets públicas</td>
<td><code>amazon-eks-vpc-sample.yaml</code></td>
</tr>
<tr>
<td><code>VPC_SUBNET</code></td>
<td>Rango CIDR para la nueva VPC.</td>
<td><code>192.169.0.0/16</code></td>
</tr>
<tr>
<td><code>VPC_SUBNET_B1</code></td>
<td>Rango de CIDR para la subred pública 1</td>
<td><code>192.169.64.0/18</code></td>
</tr>
<tr>
<td><code>VPC_SUBNET_B2</code></td>
<td>Rango de CIDR para la subred pública 2</td>
<td><code>192.169.128.0/18</code></td>
</tr>
<tr>
<td><code>VPC_SUBNET_B3</code></td>
<td>Rango de CIDR para la subred pública 3</td>
<td><code>192.169.192.0/18</code></td>
</tr>
<tr>
<td><code>ARN_ROLE</code></td>
<td>Rol requerido para la configuración del clúster EKS</td>
<td><code>""</code></td>
</tr>
<tr>
<td><code>WN_STACK_TEMPLATE</code></td>
<td>Template para creación de Worker Nodes</td>
<td><code>amazon-eks-nodegroup.yaml</code></td>
</tr>
<tr>
<td><code>EC2_DISK_SIZE</code></td>
<td>Tamaño de disco para instancias EC2 que componen el Work Group</td>
<td><code>20 GB</code></td>
</tr>
<tr>
<td><code>EC2_INSTANCE_TYPE</code></td>
<td>Tipo de Instancia EC2 del Work Group</td>
<td><code>t2.medium</code></td>
</tr>
<tr>
<td><code>EC2_IMAGE_ID</code></td>
<td>AMIID - ID de imágen Sistema operativo para Worker Nodes </td>
<td><code>ami-0f15d55736fd476da (Amazon Linix 2)</code></td>
</tr>
<tr>
<td><code>SCALING_MIN_SIZE</code></td>
<td>Número mínimo de instancias EC2 en el Work Group</td>
<td><code>1</code></td>
</tr>
<tr>
<td><code>SCALING_MAX_SIZE</code></td>
<td>Número máximo de instancias EC2 en el Work Group</td>
<td><code>4</code></td>
</tr>
<tr>
<td><code>AWS_KEY_NAME</code></td>
<td>Número deseado de instancias EC2 en el Work Group</td>
<td><code>2</code></td>
</tr>
</tbody>
</table>



[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html

<h2>License</h2>

All the code in this repo is under ![picture](https://img.shields.io/badge/license-MIT-brightgreen)

```
MIT License

Copyright (c) 2019 
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
