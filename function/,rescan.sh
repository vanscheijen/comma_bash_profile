,rescan () {
    local f_info="Rescan all disks to check if their sizes have changed, outputs last kernel messages as information"

    for i in /sys/class/scsi_host/*/scan; do
        echo "- - -" >| "$i"
    done
    for i in /sys/class/scsi_device/*/device/rescan /sys/block/*/device/rescan; do
        echo 1 >| "$i"
    done

    dmesg | tail
}

