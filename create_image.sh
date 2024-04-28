#!/bin/bash

readonly SCRIPT_DIR=$(cd $(dirname $0); pwd)
readonly CONFIG_FILE=${SCRIPT_DIR}/config/cloud_config.yaml

CLEANUP=()

readonly cdrom=$(ls -t ubuntu-*-live-server-amd64.iso | head -1)

add_cleanup() {
    local cmd=""
    local arg
    for arg; do
        echo $cmd
        cmd+=$(printf "%q " "$arg")
    done
    CLEANUP+=("$cmd")
}

do_cleanup() {
    trap - EXIT

    for ((i=${#CLEANUP[@]}; i > 0; i--)); do
        local cmd="${CLEANUP[$((i-1))]}"
        $cmd || { error "Command: '$cmd' failed!"; }
    done
}

trap do_cleanup EXIT

machine_name="nest"

user_data="$(mktemp /tmp/user-data.XXXXXXXX)"
add_cleanup rm -f "${user_data}"

cat > "$user_data" <<EOF
#cloud-config
autoinstall:
  version: 1
  identity:
    realname: user
    hostname: nest
    username: 'user'
    password: 'user'
  ssh:
    install-server: yes
  storage:
    layout:
      name: direct
EOF

readonly seed=$(mktemp ./seed-XXXXXX.iso)
add_cleanup rm -f "${seed}"

cloud-localds "$seed" "$user_data"

echo "Mounting cdrom"

mount_point="$(mktemp -d)"
add_cleanup rm -rf "$mount_point"

7z x "${cdrom}" -o"${mount_point}"

image="vm-image.iso"

ls "${mount_point}/casper/"
ls "${mount_point}/casper/vmlinuz"
ls "${mount_point}/casper/initrd"

truncate -s 10G $image

qemu-system-x86_64 -no-reboot -boot d \
  -nographic \
  -m 4096 \
  -bios /usr/share/qemu/OVMF.fd \
  -drive file="${image}",format=raw,cache=none,if=virtio \
  -drive file="${seed}",format=raw,cache=none,if=virtio \
  -cdrom "${cdrom}" \
  -kernel "$mount_point/casper/vmlinuz" \
  -initrd "$mount_point/casper/initrd" \
  -append 'autoinstall console=tty50'