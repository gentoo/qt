# Markos Chandras <hwoarang@gentoo.org>
# Oneliner for bumping kde-qt ebuilds
# use it like
# bump-kde-qt <old version> <new version>
# This will copy the <old version> ebuilds to <new version>
# New version is always using 4.9999 ebuilds 
# Lets say you want to bump 4.4.9999 ebuilds to 4.5.9999 you have to write:
#
# ./bump-kde-qt 4.4.9999 4.5.9999
#
source /etc/init.d/functions.sh
#### VARIABLES ####
HOME="`pwd|xargs dirname|xargs dirname`"
LIBS="x11-libs"
EXCLUDE="qt-embedded"
old="${1}"
new="${2}"
#################
cd ${HOME}/${LIBS}
## update ebuilds and create manifest ##
ebegin "Updating ebuilds"
for package in $(ls |grep -v ${EXCLUDE}|grep qt);do cd ${package};rm $(ls|grep ${old});cp "${package}-4.9999.ebuild" "${package}-${new}.ebuild";git add "${package}-${new}.ebuild";echangelog "Version bump to ${new}">>/dev/null;repoman manifest;cd ${HOME}/${LIBS};done
eend $?
## update sets ##
ebegin "Updating sets"
cd ${HOME}/sets
sed -i "s/${old}/${new}/" qt-all-live-kde
eend $?
## update package keywords ##
cd ${HOME}/Documentation/package.keywords/
ebegin "Updating package keywords"
sed -i "s/${old}/${new}/" qt-live-kde
eend $?
## add and commit but DONT push ##
cd ${HOME}
ebegin "Ready to commit"
git add .
eend $?
