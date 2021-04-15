
. ./lib/unlinebreak.jq.lib.sh

# apt-cache show make

data_sample() {
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

result="$(
data_sample | jq -MrR "$jq_function_unlinebreak"'[.,inputs]|unlinebreak(startswith(" "))|map(join(""))|.[]'
)"

expected='Package: make
Version: 4.2.1-1.2
Maintainer: Manoj Srivastava <srivasta@debian.org>
Description-en: utility for directing compilation GNU Make is a utility which controls the generation of executables and other target files of a program from the program'\''s source files. It determines automatically which pieces of a large program need to be (re)created, and issues the commands to (re)create them. Make can be used to organize any task in which targets (files) are to be automatically updated based on input files whenever the corresponding input is newer --- it is not limited to building computer programs. Indeed, Make is a general purpose dependency solver.
Description-md5: 3ef13fe0be8e85cb535b13ff062ae8eb
Homepage: https://www.gnu.org/software/make/
Tag: devel::buildtools, implemented-in::c, interface::commandline, role::program, scope::utility, suite::gnu, works-with::software:source
Section: devel
Filename: pool/main/m/make-dfsg/make_4.2.1-1.2_amd64.deb'

[ "$result" = "$expected" ] && echo ok || echo KO
