#!/bin/bash
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.26.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.26.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.26.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.26.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.6-0
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.9.3
docker pull quay.io/coreos/flannel:v0.15.1-amd64

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.26.3 k8s.gcr.io/kube-apiserver:v1.26.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.26.3 k8s.gcr.io/kube-controller-manager:v1.26.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.26.3 k8s.gcr.io/kube-scheduler:v1.26.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.26.3 k8s.gcr.io/kube-proxy:v1.26.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9 k8s.gcr.io/pause:3.9
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.6-0 k8s.gcr.io/etcd:3.5.6-0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.9.3 k8s.gcr.io/coredns/coredns:v1.9.3

docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.26.3
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.26.3
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.26.3
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.26.3
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.6-0
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.9.3