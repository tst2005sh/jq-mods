
. ./lib/unlinebreak.jq.lib.sh

# apt-cache show make

data_sample_apt() {
cat<<EOF
Package: make
Version: 4.2.1-1.2
Maintainer: Manoj Srivastava <srivasta@debian.org>
Description-en: utility for directing compilation
 GNU Make is a utility which controls the generation of executables
 and other target files of a program from the program's source
 files. It determines automatically which pieces of a large program
 need to be (re)created, and issues the commands to (re)create
 them. Make can be used to organize any task in which targets (files)
 are to be automatically updated based on input files whenever the
 corresponding input is newer --- it is not limited to building
 computer programs. Indeed, Make is a general purpose dependency
 solver.
Description-md5: 3ef13fe0be8e85cb535b13ff062ae8eb
Homepage: https://www.gnu.org/software/make/
Tag: devel::buildtools, implemented-in::c, interface::commandline,
 role::program, scope::utility, suite::gnu, works-with::software:source
Section: devel
Filename: pool/main/m/make-dfsg/make_4.2.1-1.2_amd64.deb
EOF
}
expected="$(
cat<<EOF
Package: make
Version: 4.2.1-1.2
Maintainer: Manoj Srivastava <srivasta@debian.org>
Description-en: utility for directing compilation GNU Make is a utility which controls the generation of executables and other target files of a program from the program's source files. It determines automatically which pieces of a large program need to be (re)created, and issues the commands to (re)create them. Make can be used to organize any task in which targets (files) are to be automatically updated based on input files whenever the corresponding input is newer --- it is not limited to building computer programs. Indeed, Make is a general purpose dependency solver.
Description-md5: 3ef13fe0be8e85cb535b13ff062ae8eb
Homepage: https://www.gnu.org/software/make/
Tag: devel::buildtools, implemented-in::c, interface::commandline, role::program, scope::utility, suite::gnu, works-with::software:source
Section: devel
Filename: pool/main/m/make-dfsg/make_4.2.1-1.2_amd64.deb
EOF
)"

result="$(
	data_sample_apt |
	jq -MrR "$jq_function_unlinebreak"'
		[.,inputs]
		| unlinebreak(startswith(" "))
		| map(join(""))
		| .[]
	'
)"

[ "$result" = "$expected" ] && echo ok apt || echo KO apt


# rpm -qi make kbd-legacy
# rpm -qai 

data_sample_rpm() {
cat<<EOF
Name        : make
Epoch       : 1
Version     : 3.82
Release     : 24.el7
Architecture: x86_64
Install Date: Wed 16 Oct 2019 09:21:42 AM PDT
Group       : Development/Tools
Size        : 1160660
License     : GPLv2+
Signature   : RSA/SHA256, Thu 22 Aug 2019 02:34:59 PM PDT, Key ID 24c6a8a7f4a80eb5
Source RPM  : make-3.82-24.el7.src.rpm
Build Date  : Thu 08 Aug 2019 05:47:25 PM PDT
Build Host  : x86-01.bsys.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://www.gnu.org/software/make/
Summary     : A GNU tool which simplifies the build process for users
Description :
A GNU tool for controlling the generation of executables and other
non-source files of a program from the program's source files. Make
allows users to build and install packages without any significant
knowledge about the details of the build process. The details about
how the program should be built are provided for make in the program's
makefile.
Name        : kbd-legacy
Version     : 1.15.5
Release     : 15.el7
Architecture: noarch
Install Date: Thu 15 Aug 2019 10:53:08 AM PDT
Group       : System Environment/Base
Size        : 503608
License     : GPLv2+
Signature   : RSA/SHA256, Mon 12 Nov 2018 07:17:49 AM PST, Key ID 24c6a8a7f4a80eb5
Source RPM  : kbd-1.15.5-15.el7.src.rpm
Build Date  : Tue 30 Oct 2018 03:40:00 PM PDT
Build Host  : x86-01.bsys.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://ftp.altlinux.org/pub/people/legion/kbd
Summary     : Legacy data for kbd package
Description :
The kbd-legacy package contains original keymaps for kbd package.
Please note that kbd-legacy is not helpful without kbd.
EOF
}

expected="$(
cat<<EOF
Name        : make
Epoch       : 1
Version     : 3.82
Release     : 24.el7
Architecture: x86_64
Install Date: Wed 16 Oct 2019 09:21:42 AM PDT
Group       : Development/Tools
Size        : 1160660
License     : GPLv2+
Signature   : RSA/SHA256, Thu 22 Aug 2019 02:34:59 PM PDT, Key ID 24c6a8a7f4a80eb5
Source RPM  : make-3.82-24.el7.src.rpm
Build Date  : Thu 08 Aug 2019 05:47:25 PM PDT
Build Host  : x86-01.bsys.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://www.gnu.org/software/make/
Summary     : A GNU tool which simplifies the build process for users
Description : A GNU tool for controlling the generation of executables and othernon-source files of a program from the program's source files. Makeallows users to build and install packages without any significantknowledge about the details of the build process. The details abouthow the program should be built are provided for make in the program'smakefile.
Name        : kbd-legacy
Version     : 1.15.5
Release     : 15.el7
Architecture: noarch
Install Date: Thu 15 Aug 2019 10:53:08 AM PDT
Group       : System Environment/Base
Size        : 503608
License     : GPLv2+
Signature   : RSA/SHA256, Mon 12 Nov 2018 07:17:49 AM PST, Key ID 24c6a8a7f4a80eb5
Source RPM  : kbd-1.15.5-15.el7.src.rpm
Build Date  : Tue 30 Oct 2018 03:40:00 PM PDT
Build Host  : x86-01.bsys.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://ftp.altlinux.org/pub/people/legion/kbd
Summary     : Legacy data for kbd package
Description : The kbd-legacy package contains original keymaps for kbd package.Please note that kbd-legacy is not helpful without kbd.
EOF
)"

result="$(
	data_sample_rpm |
	jq -cMRr "$jq_function_unlinebreak"'
		[.,inputs]
		| unlinebreak( (test("^([A-Z]\\w+ *)+\\s*:")|not) )
		| map(if length>1 and (first|endswith(":")) then .[0]|=(.+" ") else . end)
		| map(join(""))
		| .[]
	'
)"

[ "$result" = "$expected" ] && echo ok rpm || echo KO rpm

