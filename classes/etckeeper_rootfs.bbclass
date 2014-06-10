inherit image_types

etckeeper_rootfs_pre () {
    # Since we don't have /etc/etckeeper in the image yet, we take it
    # from the sysroot
    export ETCKEEPER_CONF_DIR=${STAGING_DIR_NATIVE}${libdir}/etckeeper
    export ETCKEEPER_DEST=${IMAGE_ROOTFS}
    export ETCKEEPER_REPO=${ETCKEEPER_DEST}${sysconfdir}
    # Initialize repo
    etckeeper init -d ${ETCKEEPER_REPO}
}

etckeeper_rootfs_post () {
    export ETCKEEPER_CONF_DIR=${IMAGE_ROOTFS}${sysconfdir}/etckeeper
    export ETCKEEPER_DEST=${IMAGE_ROOTFS}
    export ETCKEEPER_REPO=${ETCKEEPER_DEST}${sysconfdir}
    etckeeper commit -d ${ETCKEEPER_REPO} "${IMAGE_NAME}: rootfs creation"
}

ROOTFS_PREPROCESS_COMMAND += "etckeeper_rootfs_pre ; "
ROOTFS_POSTPROCESS_COMMAND += "etckeeper_rootfs_post ; "

IMAGE_CMD_etckeeper-bare () {
    DEPLOY_ETC=${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.etc.git
    mkdir ${DEPLOY_ETC}
    cd ${DEPLOY_ETC}
    git init --bare
    cd ${IMAGE_ROOTFS}${sysconfdir}
    git push file://${DEPLOY_ETC} master
}

do_rootfs[depends] += "etckeeper-native:do_populate_sysroot"
