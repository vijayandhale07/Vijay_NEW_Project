#!/usr/bin/sh

set -x  # Debug mode

LOGFILE="/stag1/FMCC_STAG_CLEAN_UP/logs/log/cleanup_$(date +%Y%m%d).log"
echo "Cleanup started at $(date)" >> "$LOGFILE"

# Function to safely delete files by pattern
# Function to delete by mtime
delete_by_mtime() {
    local dir="$1"
	local days="$2"
	local pattern="$3"
	
    echo "[$(date +%d-%m-%Y_%T)] Deleting files older than $days days in $dir" >> "$LOGFILE"
##    find "$dir" -type f -name "$pattern" -mtime +"$days" -print -delete >> "$LOGFILE" 2>&1
}

# Clean CHI1/CHI2 GMSC files
delete_by_mtime "/stag1/NOKIA_MSC_RAW/MH" 2 "*CHI1_NOKIA*"
delete_by_mtime "/stag1/NOKIA_MSC_RAW/MH" 2 "*CHI2_NOKIA*"

# Uncomment if needed for GGSN
# delete_by_mtime "/stag1/NOKIA_GGSN" "*BSGW*"

# ALU cleanup (older than 0 days = today and older)
delete_by_mtime "/stag1/ALU_MSC_RAW" 1
delete_by_mtime "/stag1/ALU_GMSC_RAW" 1

# TAPIN and TAPOUT directories cleanup (> 1 day old)
for loc in MH MP GJ; do
    delete_by_mtime "/stag2/TAPIN/$loc" 1
    delete_by_mtime "/stag2/TAPOUT/$loc" 1
done

# Special subdir
delete_by_mtime "/stag2/TAPOUT/MP/VDF" 1

# GPRS cleanup
delete_by_mtime "/stag/GPRS" 1

echo "Cleanup completed at $(date)" >> "$LOGFILE"

exit 0



