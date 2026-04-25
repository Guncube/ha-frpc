#!/usr/bin/env bashio
set -e

CONFIG_SRC="/defaults/frpc_template.toml"
CONFIG_DST="/data/frpc.toml"

trap 'bashio::log.info "Shutting down FRPC..."; kill ${FRPC_PID} ${TAIL_PID}; exit' SIGTERM SIGHUP

bashio::log.info "Preparing configuration..."

bashio::log.info "Configuration:"
cat ${CONFIG_DST}

bashio::log.info "Starting FRPC client..."
/usr/bin/frpc -c ${CONFIG_DST} & FRPC_PID=$!

bashio::log.info "Tailing logs..."
tail -F /share/frpc.log & TAIL_PID=$!

wait ${FRPC_PID}
