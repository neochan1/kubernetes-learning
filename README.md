# kubernetes-learning
## kubernetes v1.26
### 搭建一个三节点的k8s集群
准备工作:  
准备三台centos7.8虚拟机，推荐配置(master节点：8核16G;node节点:4核8G*2;硬盘至少20G)

#### 初始化节点  
1. 关闭 SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
2. 设置路由
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF  

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF  


sysctl --system  

3. 关闭系统的 Swap
swapoff -a
sed -i '$a\vm.swappiness=0' /etc/sysctl.d/k8s.conf  

sysctl -p /etc/sysctl.d/k8s.conf  

#### 安装并启动k8s集群
1. 安装docker,这里不再赘述,参考https://developer.aliyun.com/article/110806  
2. 配置kubernetes yum源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF  

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes  
systemctl enable kubelet  && systemctl restart kubelet

3. 修改docker配置
cat > /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2",
"storage-opts": [
"overlay2.override_kernel_check=true"
],
"data-root": "/data/docker",
"registry-mirrors": ["https://b0f9uu1x.mirror.aliyuncs.com"]
}
EOF  

4. 查看需要的镜像
kubeadm config images list  

registry.k8s.io/kube-apiserver:v1.26.3
registry.k8s.io/kube-controller-manager:v1.26.3
registry.k8s.io/kube-scheduler:v1.26.3
registry.k8s.io/kube-proxy:v1.26.3
registry.k8s.io/pause:3.9
registry.k8s.io/etcd:3.5.6-0
registry.k8s.io/coredns/coredns:v1.9.3

5. 从国内源拉取镜像
参考 docker_push.sh

6. 初始化集群  
kubeadm init --apiserver-advertise-address=192.168.5.134 --pod-network-cidr=10.244.0.0/16  

出现如下信息：
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.5.134:6443 --token ozedpd.p8dz6ca5wm0q0orw --discovery-token-ca-cert-hash sha256:0d85585d4f96824d4ff2b9e31bc59d26ceeb15cb26459965a0d08292fb61ec7a

7. 导入admin配置  
export KUBECONFIG=/etc/kubernetes/admin.conf

8. 网络配置,使用flannel网络插件
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml  

master节点搭建完毕

#### 把worker节点加入集群
在两个worker节点都执行 kubeadm join 192.168.5.134:6443 --token ozedpd.p8dz6ca5wm0q0orw --discovery-token-ca-cert-hash sha256:0d85585d4f96824d4ff2b9e31bc59d26ceeb15cb26459965a0d08292fb61ec7a

至此，三节点集群搭建完毕








