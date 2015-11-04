#!/usr/bin/env python
#
# Remove unused docker volumes

import os
import subprocess
import shutil

ROOT_VFS = '/var/lib/docker/vfs/dir'
ROOT_VOLUMES = '/var/lib/docker/volumes'


def docker_container_id():
    """retrieve docker container ids."""
    proc = subprocess.Popen(
        ('docker', 'ps', '-aq'),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    r, e = proc.communicate()
    return r.split('\n')


def docker_container_volumes(cids):
    """list all mounted volumes in docker containers."""
    fmt = lambda v: v.replace('\'', '')
    ignore = lambda v: fmt(v) in ('', '\n')
    options = (
        'docker',
        'inspect',
        '-f',
        "{{range $_, $v := .Volumes}}{{$v}}|{{end}}"
    )
    volumes = []
    for cid in cids:
        proc = subprocess.Popen(
            options + (cid,),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
        r, e = proc.communicate()
        volumes.extend([fmt(v) for v in r.split('|') if not ignore(v)])
    return list(set(volumes))


def docker_filter_vfs(volumes):
    """filter volumes created automatically."""
    is_vfs = lambda v: v.startswith(ROOT_VFS) or v.startswith(ROOT_VOLUMES)
    return [v for v in volumes if is_vfs(v)]


def docker_to_remove_vfs(volumes):
    """list all pathnames to be removed from vfs."""
    return _to_remove(volumes, ROOT_VFS)


def docker_to_remove_volumes(volumes):
    """list all pathnames to be removed from volumes."""
    return _to_remove(volumes, ROOT_VOLUMES)


def _to_remove(volumes, root):
    as_id = lambda v: os.path.basename(v)
    as_path = lambda v: os.path.join(root, v)
    dirs = set([v for v in os.listdir(root)])
    svolumes = set([as_id(i) for i in volumes])
    return [as_path(v) for v in dirs.difference(svolumes)]


def docker_to_remove(volumes):
    """list all pathnames to be removed"""
    remove = docker_to_remove_vfs(volumes)
    remove.extend(docker_to_remove_volumes(volumes))
    return list(set(remove))


def docker_remove(volumes):
    """remove all listed pathnames."""
    return [shutil.rmtree(v) for v in volumes]


def main():
    """execute the list/removal of unused volumes."""
    return docker_remove(docker_to_remove(
        docker_filter_vfs(docker_container_volumes(docker_container_id()))
    ))


if __name__ == '__main__':
    main()
