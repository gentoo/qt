TEMPLATE = lib
CONFIG += qt plugin link_pkgconfig

QT = core gui

LIBS += $$QMAKE_LIBS_X11
LIBS += -L/usr/lib64/qt4
QMAKE_CXXFLAGS += $$QT_CFLAGS_QGTKSTYLE
LIBS_PRIVATE += $$QT_LIBS_QGTKSTYLE

unix:QMAKE_PKGCONFIG_REQUIRES = QtGui

PKGCONFIG += gdk-x11-2.0
PKGCONFIG += atk

contains(QT_CONFIG, reduce_exports):CONFIG += hide_symbols

TARGET   = $$qtLibraryTarget(gtkstyle)

INCLUDEPATH += $$PWD/dialogs

FORMS += dialogs/qfiledialog.ui
HEADERS  = styles/qgtkstyle.h \
           styles/qgtkpainter_p.h \
	   styles/qgtkstyle_p.h \
	   styles/qstylehelper_p.h \
	   styles/qwindowsstyle.h \
	   image/qiconloader_p.h \
	   kernel/qguiplatformplugin_p.h \
	   kernel/qkde_p.h \
	   dialogs/qfiledialog_p.h \
	   dialogs/qfiledialog.h \
	   dialogs/qsidebar_p.h \
	   dialogs/qfilesystemmodel.h \
	   dialogs/qfileinfogatherer_p.h
SOURCES  = styles/main.cpp \
	   styles/qgtkstyle.cpp \
           styles/qgtkpainter.cpp \
	   styles/qgtkstyle_p.cpp \
	   styles/qstylehelper.cpp \
	   styles/qwindowsstyle.cpp \
	   image/qiconloader.cpp \
	   kernel/qguiplatformplugin.cpp \
	   kernel/qkde.cpp \
	   dialogs/qsidebar.cpp \
	   dialogs/qfiledialog.cpp \
	   dialogs/qfilesystemmodel.cpp \
	   dialogs/qfileinfogatherer.cpp
# RESOURCES = qstyle.qrc

include(../qbase.pri)

contains(QT_CONFIG, x11sm):CONFIG += x11sm

#platforms
x11:include(kernel/x11.pri)
mac:include(kernel/mac.pri)
win32:include(kernel/win.pri)

# target.path = $$[QT_INSTALL_PLUGINS]/styles
# INSTALLS += target
