
SATA=/dev/sda
FIRST_PART="/dev/sda1"
SEC_PART="/dev/sda2"

# Database partition
DB_START_SECTOR=2048
DB_STOP_SECTOR=41945087

# Backup partition
BU_START_SECTOR=41945088
BU_STOP_SECTOR=62533295

# tmp partition
TM_START_SECTOR=52111079
TM_STOP_SECTOR=62533295

CREATEPARTITION="/scripts/CreateSATAPartition.sh"
FIRST="1"
SECOND="2"

ALL_PERM="777"

# database mount point 
DB_MOUNT_PT="/database"
BKP_MOUNT_PT="/temp_data"

# Fsck reboot file 
FSCK_REBOOT_FILE="/var/log/fsckReboot.log"

EXCLAMATION_LED_LED_RED_OFF="echo 0 > /sys/class/leds/en-led4/brightness"
EXCLAMATION_LED_LED_RED_ON="echo 1 > /sys/class/leds/en-led4/brightness"
EXCLAMATION_LED_LED_GREEN_OFF="echo 0 > /sys/class/leds/en-led8/brightness"
EXCLAMATION_LED_LED_GREEN_ON="echo 1 > /sys/class/leds/en-led8/brightness"

BLINKEXCLAMLED="/scripts/BlinkExclaLed.sh"

DISK_ABSENT_LED_ON_TIME=0.1
DISK_ABSENT_LED_OFF_TIME=0.1
DISK_INVALID_LED_ON_TIME=0.1
DISK_INVALID_LED_OFF_TIME=0.2
DISK_CORRUPT_LED_ON_TIME=0.1
DISK_CORRUPT_LED_OFF_TIME=0.3

DISK_ABSENT_LED_ON_TIME=0.1
DISK_ABSENT_LED_OFF_TIME=0.1
DISK_INVALID_LED_ON_TIME=0.1
DISK_INVALID_LED_OFF_TIME=0.2
DISK_CORRUPT_LED_ON_TIME=0.1
DISK_CORRUPT_LED_OFF_TIME=0.3

