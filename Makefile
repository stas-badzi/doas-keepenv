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

ifneq ($(wildcard /etc/nixos),$(empty))
force-nix=1
endif

ifneq ($(force-nix),1)

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
else

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

else

ifneq ($(wildcard /etc/arch-release),$(empty))

distro=$(shell cat /etc/os-release | grep "ID=" | grep -v "_ID=" | sed 's/ID=//g')

pkgname=doas-keepenv-$(version)-$(release)-$(arch3).$(distro).pkg.tar.zst
realpkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.zst
# pkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.xz
# pkgname=doas-keepenv-$(version)-$(release)-$(arch3).pkg.tar.gz

build/bin/$(pkgname): doas-keepenv build/bin/.SRCINFO
	cd build/pkg; makepkg -sf
	cp build/pkg/$(realpkgname) build/bin/$(pkgname)

build/bin/.SRCINFO: build/conf/PKGBUILD
	cat build/conf/PKGBUILD | sed 's/\%/$(version)/g' | sed 's/\!/$(release)/g' > build/pkg/PKGBUILD
	mkdir -p build/bin
	cd build/pkg; makepkg --printsrcinfo > ../bin/.SRCINFO

install: build/bin/$(pkgname)
	pacman -U build/bin/$(pkgname)

clean:
	rm -rf build/bin build/pkg/pkg build/pkg/src build/pkg/$(pkgname) build/pkg/$(version).tar.gz build/pkg/PKGBUILD

else

ifneq ($(wildcard /etc/nix),$(empty))
force-nix=1
$(warning Falling back to nix build)
else
$(error No supported package manager found on this system)
endif

endif
endif
endif

endif

ifeq ($(force-nix),1)
ifneq ($(wildcard /etc/nix),$(empty))

narname=doas-keepenv-$(version)-$(release).nar
nixname=doas-keepenv-$(version)-$(release).nix

build/bin/$(narname): build/bin/$(nixname)
	nix-build build/bin/$(nixname) -o build/bin/result
	nix-store --export $$(nix-store --query --requisites build/bin/result) > build/bin/$(narname)

build/bin/$(nixname): build/conf/default.nix
	mkdir -p build/bin
	cat build/conf/default.nix | sed 's/\%/$(version)/g' > build/bin/$(nixname)

install: build/bin/$(narname)
	nix-store --import --no-require-sigs < build/bin/$(narname)

publish: build/bin/$(narname)
	cd $$(mktemp -d); git clone https://github.com/stas-badzi/nix-channel.git; cd nix-channel; mkdir -p pkgs/doas-keepenv; cat $(current_dir)/build/bin/$(nixname) | sed 's/pkgs ? import <nixpkgs> {}/stdenv,lib,coreutils,doas,makeWrapper,fetchurl,/g' | sed 's/pkgs.//g' > pkgs/doas-keepenv/default.nix; make publish k=$(k); git add pkgs/doas-keepenv/default.nix; git commit -m "doas-keepenv: $(version)-$(release)"; git push
	cd $$(mktemp -d); git clone https://github.com/stas-badzi/doas-keepenv.git; cd doas-keepenv; git switch github-pages; cp $(current_dir)/build/bin/$(nixname) default.nix; git add default.nix; git commit -m "$(version)-$(release)"; git push
clean:
	rm -rf build/bin
	rm build/nar/default.nix

else
$(error Nix not installed in /etc on this system)
endif

endif