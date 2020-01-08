#!/bin/bash
minikube start --kubernetes-version v1.14.9 --cpus=2 --memory='4g' --extra-config=apiserver.authorization-mode=RBAC