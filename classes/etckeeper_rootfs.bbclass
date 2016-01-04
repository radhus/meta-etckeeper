inherit image_types


ETCKEEPER_REBASE_REPO ??= ""
ETCKEEPER_REBASE_REV ??= "master"

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
    cd ${ETCKEEPER_REPO}
    if [ "${ETCKEEPER_REBASE_REPO}" != "" ]; then
        git fetch "${ETCKEEPER_REBASE_REPO}" "${ETCKEEPER_REBASE_REV}"
        # recreate the commit with a new parent
        git reset --soft FETCH_HEAD
        git commit -C "HEAD@{1}"
    fi
    # cleanup repo
    git reflog expire --expire=now --all
    git gc --aggressive --prune=now
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
    rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.etc.git
    ln -s ${IMAGE_NAME}.etc.git ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.etc.git
}

do_rootfs[depends] += "etckeeper-native:do_populate_sysroot"
