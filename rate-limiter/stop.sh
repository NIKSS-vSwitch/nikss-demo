#!/bin/bash

echo "Removing rate-limiter rules..."

set -xe

psabpf-ctl meter reset pipe "$PIPELINE" DemoIngress_meter index "$SWITCH_SERVER1_PORT_ID"

echo "Removed rate-limiter successfully!"