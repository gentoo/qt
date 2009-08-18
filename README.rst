Welcome to the qting-edge overlay!
==================================

This is where the Gentoo Qt team develops and maintains ebuilds for
experimental Qt4 versions (pre-releases and "live" code from git or svn) and
Qt4 related packages. For your convenience we provide some sets and
``package.keyword`` files.

Please note that we use the following versioning scheme:

- 4.x.y_beta, 4.x.y_rc are official pre-releases
- 4.9999 is "live" code from Nokia's Qt Software git repository
- 4.x.9999 is "live" code from KDE's qt-copy git repository

The corresponding sets we defined are:

qt-all-4.5
	the latest official pre-release.
qt-all-live-nokia
	"live" code from Nokia's Qt Software git repo.
qt-all-live-kde
	"live" code from KDE's qt-copy git repo.

If you want to use qt-copy, you should mask the official pre-releases.

You don't need to emerge the Qt ebuilds specifically, they are normally pulled
in as dependencies for packages that use Qt4. But you may want to have all of
Qt4 installed, for example if you are a developer or tester. In that case we
recommend you copy the most applicable set to your ``/etc/portage/sets/``
directory, rename it (to prevent portage error on set redefinition), and
customize it to your own wishes.

KDE users should note that at this point they need to use the
media-sound/phonon package instead of x11-libs/qt-phonon. As a result we have
commented out qt-phonon in the qt-all-live-kde set. Apart from that, KDE can
use the official Nokia Qt version, but has specific patches in qt-copy that
should result in a smoother KDE user experience.

Non-KDE users should stick to the official Qt packages from Nokia Qt Software
(previously Trolltech).

If you have questions, you can find us on IRC in #gentoo-kde on Freenode or at
qt@gentoo.org.

Bugs should be reported on https://bugs.gentoo.org. Be sure to include
[qting-edge] in the summary of your bug report.

Users wanting to contribute should first read the `Qt4 ebuild guide
<http://www.gentoo.org/proj/en/desktop/kde/qt4-based-ebuild-howto.xml>`_.

Happy Qting!

The Gentoo Qt team
