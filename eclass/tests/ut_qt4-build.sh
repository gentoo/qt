#!/bin/bash
#
# qt4-build.eclass Unit Test
#
# Dominik Kapusta <ayoy@gentoo.org>

source tests-common.sh

test_standard_configure_options-USE_data() {
    if [[ -z "$1" ]]; then
        echo 4
    else
        case $1 in
        1)
            USE=pch
            # don't match -no-pch
            myconf_string="[^o]-pch"
            ;;
        2)
            USE=-pch
            myconf_string="-no-pch"
            ;;
        3)
            USE=debug
            myconf_string="-debug -no-separate-debug-info"
            ;;
        4)
            USE=-debug
            myconf_string="-release -no-separate-debug-info"
            ;;
        *)
            ;;
        esac
    fi
}

test_standard_configure_options-USE() {
    local data_sets=$(${FUNCNAME}_data)
    local myconf_string=
    parse_version "qt-gui" "4.6.0"

    for x in $(seq 1 ${data_sets}); do
        ${FUNCNAME}_data ${x}

        ebegin "Testing USE=\"${USE}\""

        inherit qt4-build

        local myconf=$(standard_configure_options)
        if [[ "${myconf}" =~ ${myconf_string} ]]; then
            let pass++
            eend 0
        else
            let fail++
            eend 1
        fi
    done
}

test_standard_configure_options-PV_data() {
    if [[ -z "$1" ]]; then
        echo 6
    else
        case $1 in
        1)
            PV="4.4.2"
            opensource=false
            ;;
        2)
            PV="4.5.0"
            opensource=true
            ;;
        3)
            PV="4.5.1"
            opensource=true
            ;;
        4)
            PV="4.5.2"
            opensource=true
            ;;
        5)
            PV="4.5.3"
            opensource=true
            ;;
        6)
            PV="4.6.0_beta1"
            opensource=true
            ;;
        *)
            ;;
        esac
    fi
}

test_standard_configure_options-PV() {
    local data_sets=$(${FUNCNAME}_data)
    local opensource=

    for x in $(seq 1 ${data_sets}); do
        ${FUNCNAME}_data ${x}
        parse_version "qt-core" ${PV}

        ebegin "Testing PV=\"${PV}\""

        inherit qt4-build

        local myconf=$(standard_configure_options)
        [[ "${myconf}" =~ -opensource ]]
        local res=$?
        #test $? && res=true || res=false
        if ${opensource}; then
            res=$((!res))
        fi
        if (( ${res} )); then
            let pass++
            eend 0
        else
            let fail++
            eend 1
        fi
    done
}

test_standard_configure_options-ARCH_data() {
    if [[ -z "$1" ]]; then
        echo 4
    else
        case $1 in
        1)
            CHOST="i386"
            myconf_string="-arch ${CHOST}"
            ;;
        2)
            CHOST="x86_64"
            myconf_string="-arch ${CHOST}"
            ;;
        3)
            CHOST="powerpc"
            myconf_string="-arch ${CHOST}"
            ;;
        4)
            CHOST="arm"
            myconf_string="-arch ${CHOST}"
            ;;
        *)
            ;;
        esac
    fi
}

test_standard_configure_options-ARCH() {
    local data_sets=$(${FUNCNAME}_data)
    local myconf_string=

    for x in $(seq 1 ${data_sets}); do
        ${FUNCNAME}_data ${x}
        parse_version "qt-core" ${PV}

        ebegin "Testing CHOST=\"${CHOST}\""

        inherit qt4-build

        local myconf=$(standard_configure_options)
        if [[ "${myconf}" =~ ${myconf_string} ]]; then
            let pass++
            eend 0
        else
            let fail++
            eend 1
        fi
    done
}

test_MY_P_data() {
    if [[ -z "$1" ]]; then
        echo 6
    else
        case $1 in
        1)
            PV="4.4.2"
            TEST_MY_P="qt-x11-opensource-src-4.4.2"
            ;;
        2)
            PV="4.5.0"
            TEST_MY_P="qt-x11-opensource-src-4.5.0"
            ;;
        3)
            PV="4.5.1"
            TEST_MY_P="qt-x11-opensource-src-4.5.1"
            ;;
        4)
            PV="4.5.2"
            TEST_MY_P="qt-x11-opensource-src-4.5.2"
            ;;
        5)
            PV="4.5.3"
            TEST_MY_P="qt-x11-opensource-src-4.5.3"
            ;;
        6)
            PV="4.6.0_beta1"
            TEST_MY_P="qt-everywhere-opensource-src-4.6.0-beta1"
            ;;
        *)
            ;;
        esac
    fi
}

test_MY_P() {
    local data_sets=$(${FUNCNAME}_data)
    local myconf_string=

    for x in $(seq 1 ${data_sets}); do
        ${FUNCNAME}_data ${x}
        parse_version "qt-core" ${PV}

        ebegin "Testing PV=\"${PV}\""

        inherit qt4-build

        if [[ ${MY_P} == ${TEST_MY_P} ]]; then
            let pass++
            eend 0
        else
            let fail++
            eend 1
        fi
    done
}


PASSING=0
FAILING=0

ebegin "Unit testing qt4-build.eclass"
eindent
etest test_standard_configure_options-USE
etest test_standard_configure_options-PV
etest test_standard_configure_options-ARCH
etest test_MY_P
eoutdent
einfo "TOTAL: ${PASSING} passing, ${FAILING} failing"
[[ ${FAILING} -eq 0 ]]
eend $?
