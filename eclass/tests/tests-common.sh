#!/bin/bash

source /etc/make.globals
source /etc/init.d/functions.sh

etest() {
    ebegin "$1"
    eindent
    local pass=0 fail=0 res=false
    $1

    einfo "Passed: ${pass}, Failed: ${fail}"
    [[ ${fail} -eq 0 ]] && res=true
    if ${res}; then
        let PASSING++
        eend 0
    else
        let FAILING++
        eend 1
    fi
    eoutdent
}

inherit() {
	for e in "$@" ; do
		source ${PORTDIR}/eclass/${e}.eclass 2&>/dev/null
	done
}

emake() {
    echo "emake $*"
}

qmake() {
    echo "qmake $*"
}

find() {
    echo "find $*"
}

sed() {
    echo "sed $*"
}

die() {
    return
}

use() {
        local u=$1
        local found=0

        # if we got something like '!flag', then invert the return value
        if [[ ${u:0:1} == "!" ]] ; then
                u=${u:1}
                found=1
        fi

        # Make sure we have this USE flag in IUSE
        if [[ -n $PORTAGE_IUSE ]] ; then
                [[ $u =~ $PORTAGE_IUSE ]] || \
                        echo "QA Notice: USE Flag '${u}' not" \
                             "in IUSE for ${CATEGORY}/${PF}"
                        exit
        fi

        if [[ ${USE} =~ -${u} ]]; then
                return $((!found))
        else
                return ${found}
        fi
}

parse_version() {
    PN="${1}"
    PV="${2}"
    P="${PN}-${PV}"
}
