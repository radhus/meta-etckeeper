# Copyright (C) 2014 William Johansson <radar@radhuset.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Store /etc in git, mercurial, bzr or darcs"
HOMEPAGE = "http://kitenet.net/~joey/code/etckeeper/"
LICENSE = "GPLv2"
DEPENDS = ""
RDEPENDS_${PN} = "git"

SRC_URI = " \
    git://github.com/joeyh/etckeeper.git \
    file://0001-Remove-etckeeper.spec-build-target.patch \
    file://0002-Remove-all-usage-of-perl.patch \
    file://0003-Use-ETCKEEPER_DEST-if-present-in-.d-scripts.patch \
    file://0004-Allow-bashisms-force-bash.patch \
    file://etckeeper.conf \
    "
SRCREV = "214332b020b03e603d84ab3327f1c17509b49c47"
S = "${WORKDIR}/git"

LIC_FILES_CHKSUM = "file://GPL;md5=751419260aa954499f7abaabaa882bbe"

FILESEXTRAPATHS_append := "${THISDIR}"

do_configure() {
    cp ${WORKDIR}/etckeeper.conf ${S}
}

do_install() {
   oe_runmake DESTDIR="${D}" install
    if [ "${PN}" = "etckeeper-native" ];
    then
        # Hack to install '/etc/etckeeper' somewhere in the sysroot
        install -d -m 0755 ${D}${libdir}/etckeeper
        cp -dR ${S}/*.d ${D}${libdir}/etckeeper/
        install -m 0755 ${S}/etckeeper.conf ${D}${libdir}/etckeeper/
    fi
}


BBCLASSEXTEND = "native"
