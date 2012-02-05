===========================================
  Qt on Gentoo Frequently Asked Questions
===========================================

:Author: Ben de Groot <yngwin@gentoo.org>

.. contents::
.. sectnum::

How can I contribute to this overlay?
-------------------------------------

Please, read Documentation/maintainers/README file for proper ways to submit
bugs and patches for the Qt overlay

Why do I need qt3support?
-------------------------

First of all, qt3support is a useflag that enables the qt-qt3support module in
Qt4, as well as needed code in other Qt4 modules. It does in no way depend on
Qt3. It contains classes that make porting Qt3 applications and libraries to
Qt4 easier. They are Qt4 classes that emulate Qt3 behavior. This is really only
interesting for the developer of that package, not for the user.

Any Qt4-based package that uses these classes from Qt4's qt3support will
require the qt3support useflag to be enabled. This means the useflag needs to
be enabled for all Qt4 modules that have this useflag. Enabling it for one but
not other modules would break things, either at compile time or at runtime, so
we force the usage: it must be either enabled or disabled for all Qt ebuilds.
And as there is no package other than the Qt libraries themselves that use this
useflag, the recommendation is to enable (or disable) it globally in make.conf.

As kdelibs-4 uses these qt3support classes internally (or so I've been told,
I'm not a KDE dev or maintainer), there is a genuine requirement for qt3support
to be enabled. There is no way you can have KDE4 without qt3support in Qt4. But
this does not at all mean you need to keep Qt3 itself around. We strongly
recommend you to remove x11-libs/qt:3.

Users who do not use KDE, or anything that depends on kdelibs, should be able
to have most other Qt4 applications work without qt3support.


Why do I get blockers when trying to emerge Qt?
-----------------------------------------------

The most common causes are useflags that are not set correctly, or some but not
all Qt modules added to package.keywords. 
The former case is quite rare but in case you run into such problem please make sure that you have exactly the same use flags enabled to all of Qt modules that support them. Take qt-assistant as an example. If you build it with glib support then you have to enable glib use flag to every Qt module that makes use of it.
The later case, is quite common and this is because you probably haven't added all of Qt modules on your /etc/package.keywords files. If don't know how to do that please grab the file that match your needs from our Documentation/package.keywords folder.



What does the exceptions useflag do?
------------------------------------

The useflag description is technical, because the issue is technical. It is
enabled by default, because this is the recommended setting for Qt. See bug
240185 for a discussion. When a developer uses exceptions in his program, it
will then produce a warning on certain errors, instead of a crash. This is a
good thing, which we generally want. The downside is that the application will
use some more memory and diskspace. So in cases where those are limited (think
for example of embedded environments) it could be useful to turn this off.
That is why we have decided to offer a useflag to disable this feature, after
some users requested this.


.. vim: syntax=rest:fenc=utf-8:
