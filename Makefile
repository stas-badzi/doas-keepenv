empty=

current_dir = $(shell pwd)

ifneq ($(v),$(empty))
version=$(v)
endif

ifneq ($(V),$(empty))
version=$(V)
endif

ifeq ($(version),$(empty))
version=1.0
endif

ifneq ($(r),$(empty))
release=$(r)
endif

ifeq ($(release),$(empty))
release=1
endif

arch1=all
ifeq ($(arch1),all)
arch2=noarch
else
arch2=$(arch1)
endif
ifeq ($(arch1),all)
arch3=any
else
arch3=$(arch1)
endif

ifneq ($(wildcard /etc/debian_version),$(empty))
# .deb

distro=$(shell cat /etc/os-release | grep "ID=" | grep -v "_ID=" | sed 's/ID=//g')

distro-version=$(shell cat /etc/os-release | grep "VERSION_ID=" | sed 's/VERSION_ID=//g' | sed 's/\"//g')

debname=doas-keepenv_$(version)-$(release)$(distro)$(distro-release)$(distro-version)_$(arch1).deb

build/bin/$(debname): doas-keepenv build/conf/control
	cat build/conf/control | sed 's/\$$/$(version)/g' > build/deb/DEBIAN/control
	mkdir -p build/deb/usr/bin build/deb/usr/share/licenses/doas-keepenv build/deb/usr/share/doc/doas-keepenv
	cp doas-keepenv build/deb/usr/bin
	cp LICENSE build/deb/usr/share/licenses/doas-keepenv
	cp README.md build/deb/usr/share/doc/doas-keepenv
	
	mkdir -p build/bin
	dpkg-deb --build build/deb build/bin/$(debname)
install: build/bin/$(debname)
	apt install ./build/bin/$(debname)
clean: 
	rm -rf build/deb/DEBIAN/control build/deb/usr build/bin
endif

ifneq ($(wildcard /etc/redhat-release),$(empty))
# .rpm
dist=$(shell rpm --eval "%{?dist}")

rpmname=doas-keepenv-$(version)-$(release)$(dist).$(arch2).rpm
srcrpmname=doas-keepenv-$(version)-$(release)$(dist).src.rpm

build/bin/$(srcrmpname): build/bin/$(rpmname)
	cp $$HOME/rpmbuild/SRPMS/$(srcrpmname) build/bin

build/bin/$(rpmname): doas-keepenv build/conf/doas-keepenv.spec
	cat build/conf/doas-keepenv.spec | sed 's/\$$/$(version)/g' | sed 's/\!/$(release)/g' > build/rpm/doas-keepenv.spec
	rpmdev-setuptree
	cd $$(mktemp -d); mkdir doas-keepenv-$(version); cp $(current_dir)/* doas-keepenv-$(version); tar -czf $$HOME/rpmbuild/SOURCES/$(version).tar.gz doas-keepenv-$(version)
	
	rpmbuild -ba build/rpm/doas-keepenv.spec

	mkdir -p build/bin
	cp $$HOME/rpmbuild/RPMS/$(arch2)/$(rpmname) build/bin

install: build/bin/$(rpmname)
	dnf install build/bin/$(rpmname)

clean:
	rm -rf build/rpm/doas-keepenv.spec build/bin
	-rm $$HOME/rpmbuild/RPMS/$(arch2)/$(rpmname) $$HOME/rpmbuild/SRPMS/$(srcrpmname) $$HOME/rpmbuild/SOURCES/$(version).tar.gz
	-rmdir $$HOME/rpmbuild/RPMS/$(arch2)
	-rmdir $$HOME/rpmbuild/*
	-rmdir $$HOME/rpmbuild

endif

ifneq ($(wildcard /etc/arch-release),$(empty))

pkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.zst
# pkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.xz
# pkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.gz

build/bin/$(pkgname): doas-keepenv build/bin/.SRCINFO
	cd build/pkg; makepkg -f
	cp build/pkg/$(pkgname) build/bin/$(pkgname)

build/bin/.SRCINFO: build/conf/PKGBUILD
	cat build/conf/PKGBUILD | sed 's/\%/$(version)/g' | sed 's/\!/$(release)/g' > build/pkg/PKGBUILD
	mkdir -p build/bin
	cd build/pkg; makepkg --printsrcinfo > ../bin/.SRCINFO

install: build/bin/$(pkgname)
	pacman -U build/bin/$(pkgname)

clean:
	rm -rf build/bin build/pkg/pkg build/pkg/src build/pkg/$(pkgname) build/pkg/$(version).tar.gz build/pkg/PKGBUILD
endif
