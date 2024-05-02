SUMMARY = "Insight"

LICENSE = "CLOSED"

INSANE_SKIP:${PN} += "build-deps file-rdeps"

inherit systemd
 
SRC_URI:append = " file://scripts/ "
SRC_URI:append = " file://settings/ "
SRC_URI:append = " file://Firmware/ "
#SRC_URI:append = " file://apps/ "
SRC_URI:append = " file://db-init.service "
FILES:${PN} += " ${systemd_system_unitdir}/db-init.service "
SRC_URI:append = " file://nvme-mount.service "
FILES:${PN} += " ${systemd_system_unitdir}/nvme-mount.service "

FILES:${PN} += " /scripts "
FILES:${PN} += " /settings "
FILES:${PN} += " /Firmware "
#FILES:${PN} += " ${prefix}/src/ir/insight/apps "
#FILES:${PN} += " /usr/src/ir/insight/Firmware "
#FILES:${PN} += " /temp_data "


SYSTEMD_SERVICE:${PN} = " nvme-mount.service db-init.service "
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {

    install -d ${D}${systemd_system_unitdir}/
    install -m 0644 ${WORKDIR}/db-init.service ${D}${systemd_system_unitdir}/db-init.service
    install -m 0644 ${WORKDIR}/nvme-mount.service ${D}${systemd_system_unitdir}/nvme-mount.service

    install -d ${D}/Firmware
    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/Firmware/* ${D}/Firmware/
    chmod 775 -R ${D}/Firmware

#    install -d ${D}/usr/src/ir/insight/Firmware
#    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/Firmware/* ${D}/usr/src/ir/insight/Firmware
#    chmod 775 -R ${D}/usr/src/ir/insight/Firmware

    install -d ${D}/scripts
    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/scripts/* ${D}/scripts/
    chmod 775 -R ${D}/scripts
	
    install -d ${D}/settings
    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/settings/* ${D}/settings/
    chmod 775 -R ${D}/settings

#    install -d ${D}/temp_data
#    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/temp_data/* ${D}/temp_data

#    install -d ${D}${prefix}/src/ir/insight/apps
#    cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/apps/* ${D}${prefix}/src/ir/insight/apps/

}