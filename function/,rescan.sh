,rescan () {
    local f_info="Rescan all disks to check if their sizes have changed, outputs last kernel messages as information"

    local n
    for n in /sys/class/scsi_host/*/scan; do
        echo "- - -" >| "$n"
    done
    for n in /sys/class/scsi_device/*/device/rescan /sys/block/*/device/rescan; do
        echo 1 >| "$n"
    done

    dmesg | tail
}

