#!/bin/bash

echo "Removing rate-limiter rules..."

. ./config.env

. ./scripts/runtime_cfg.sh

set -xe

nikss-ctl meter reset pipe "$PIPELINE" DemoIngress_meter index "$SWITCH_SERVER1_PORT_ID"

echo "Removed rate-limiter successfully!"
