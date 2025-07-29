#!/usr/bin/sh
set -e
LOG_FILE="/var/log/cleanup_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "$(date '+%d-%m-%y %T') File deletion started"

cleanup() {
    local path="$1"
    local pattern="$2"
    local days="$3"

    echo "Cleaning $path - files older than $days days matching '$pattern'"
    find "$path" -type f -mtime +"$days" -name "$pattern" -exec rm -f {} +
}

cleanup_dir() {
    local path="$1"
    local days="$2"

    echo "Cleaning all files in $path older than $days days"
    find "$path" -type f -mtime +"$days" -exec rm -f {} +
}

# Sample calls
cleanup "/fms_data8/BSSAP" "*.DAT" 7
cleanup "/fms_data8/BSSAP" "*.tmp" 7
cleanup "/fms_data8/BSSAP" "*.TMP" 7
cleanup_dir "/fms_data8/RANAP" 5
cleanup_dir "/fms_data8/CDR_CONV/MSC_CDR_CONV" 2

cleanup_dir "/fms_data5/CDR_RAW/PROBE_SGSN/BACKUP" 2
cleanup "/fms_data5/CDR_RAW/PROBE_SGSN" "SGSN2_NOKIA*" 3
cleanup "/fms_data5/CDR_RAW/PROBE_SGSN" "*.dat*" 3
cleanup_dir "/fms_data5/CDR_RAW/ZTE_GGSN_PGW" 2

# Continue for all paths
# Use: cleanup "/path/to/dir" "filename_pattern" days
# Or:  cleanup_dir "/path/to/dir" days

# Optional: group by data mount point and loop for large sections

echo "$(date '+%d-%m-%y %T') File deletion completed"

