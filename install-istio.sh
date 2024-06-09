#!/bin/bash
# Istio Namespace 생성
kubectl create ns istio-system
kubectl create ns istio-ingress

# Istio 배포
helm upgrade istio-base istio/base -f istio-base/values.yaml -n istio-system -i --wait
helm upgrade istiod istio/istiod -f istiod/values.yaml -n istio-system -i --wait
helm upgrade istio-ingress istio/gateway -f istio-ingress/values.yaml -n istio-system -i --wait