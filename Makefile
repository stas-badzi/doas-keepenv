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

arch=all
ifeq ($(arch),all)
arch2=noarch
else
arch2=$(arch)
endif

ifneq ($(wildcard /etc/debian_version),$(empty))
# .deb

debname=doas-keepenv_$(version)-$(release)_$(arch).deb

$(debname): doas-keepenv build/conf/control
	cat build/conf/control | sed 's/\$$/$(version)/g' > build/deb/DEBIAN/control
	mkdir -p build/deb/usr/bin
	cp doas-keepenv build/deb/usr/bin
	
	mkdir -p build/bin
	dpkg-deb --build build/deb build/bin/$(debname)
install: $(debname)
	apt install ./$(debname)
clean: 
	rm -rf build/deb/DEBIAN/control build/deb/usr build/bin
endif

ifneq ($(wildcard /etc/redhat-release),$(empty))
# .rpm
dist=$(shell rpm --eval "%{?dist}")

rpmname=doas-keepenv-$(version)-$(release)$(dist).$(arch2).rpm
srcrpmname=doas-keepenv-$(version)-$(release)$(dist).src.rpm

$(rpmname): doas-keepenv build/conf/doas-keepenv.spec
	cat build/conf/doas-keepenv.spec | sed 's/\$$/$(version)/g' | sed 's/\!/$(release)/g' > build/rpm/doas-keepenv.spec
	rpmdev-setuptree
	cd $$(mktemp -d); mkdir doas-keepenv-$(version); cp $(current_dir)/* doas-keepenv-$(version); tar -czf $$HOME/rpmbuild/SOURCES/$(version).tar.gz doas-keepenv-$(version)
	
	rpmbuild -ba build/rpm/doas-keepenv.spec

	mkdir -p build/bin
	cp $$HOME/rpmbuild/RPMS/$(arch2)/$(rpmname) build/bin
	cp $$HOME/rpmbuild/SRPMS/$(srcrpmname) build/bin 

$(srcrmpname): $(rpmname)

clean:
	rm -rf build/rpm/doas-keepenv.spec build/bin
	-rm $$HOME/rpmbuild/RPMS/$(arch2)/$(rpmname) $$HOME/rpmbuild/SRPMS/$(srcrpmname) $$HOME/rpmbuild/SOURCES/$(version).tar.gz
	-rmdir $$HOME/rpmbuild/RPMS/$(arch2)
	-rmdir $$HOME/rpmbuild/*
	-rmdir $$HOME/rpmbuild

endif
