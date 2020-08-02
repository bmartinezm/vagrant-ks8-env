#!/bin/bash

echo "$(date)"
echo "Removing your KS8 environment."

{ # try
vagrant destroy -f

} || { # catch
    echo ""
    echo "$(date)"
    echo "The removal procedure FAILED, remove the environment manually."
    exit -1
}

echo "$(date)"
echo "The Kubernetes environment was removed successfully."
