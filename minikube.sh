#!/bin/bash
minikube start --kubernetes-version v1.16.4 --cpus=2 --memory='4g' --extra-config=apiserver.authorization-mode=RBAC