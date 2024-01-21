# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   COPYING
LICENSE = "Unknown"
LIC_FILES_CHKSUM = "file://COPYING;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = "http://ftp.us.debian.org/debian/pool/main/c/cabextract/cabextract_${PV}.orig.tar.gz"
SRC_URI[md5sum] = "3f678e8cb815f26d73e9413913b20505"
SRC_URI[sha1sum] = "e9274e4671f5cb9a351caf9a64990df6b1f49ab3"
SRC_URI[sha256sum] = "b5546db1155e4c718ff3d4b278573604f30dd64c3c5bfd4657cd089b823a3ac6"
SRC_URI[sha384sum] = "173b20f853b851a832368c8c38671127471febda37e6f90babdef01068b5032e4cc7c93482c83176fcd9eefe257930dd"
SRC_URI[sha512sum] = "416bdc5a889c3986b2a5d6ecb8526a69f2d85c34f4856da43951271ff4f31013e4197c56ea5f6b05061b511b980d5a65cb34b9b859d3013c1dbcbb89d43114f9"

# NOTE: the following library dependencies are unknown, ignoring: gnugetopt
#       (this is based on recipes that have previously been built and packaged)
DEPENDS = "libmspack"

# NOTE: if this software is not capable of being built in a separate build directory
# from the source, you should replace autotools with autotools-brokensep in the
# inherit line
inherit pkgconfig autotools

# Specify any options you want to pass to the configure script using EXTRA_OECONF:
EXTRA_OECONF = ""

