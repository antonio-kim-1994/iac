#!/bin/bash
# NKS Cluster Config 파일 설정 필요
export NCLOUD_ACCESS_KEY=ACCESSKEY
export NCLOUD_SECRET_KEY=SECRETKEY
export NCLOUD_API_GW=https://fin-ncloud.apigw.fin-ntruss.com

# ${1} : Cluster 생성 후 콘솔에서 Cluster uuid 확인 가능
# ${2} : Cluster 이름(자유롭게 작성 가능)

ncp-iam-authenticator create-kubeconfig --region FKR --clusterUuid ${1} --output ${2}-kubeconfig.yaml