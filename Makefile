empty=

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

debname=doas-keepenv_$(version)-$(release)_$(arch).deb

$(debname): doas-keepenv
	cat deb-control | sed 's/\$$/$(version)/g' > build/DEBIAN/control
	mkdir -p build/usr/bin
	cp doas-keepenv build/usr/bin
	dpkg-deb --build build $(debname)
install: $(debname)
	apt install ./$(debname)
clean:
	@echo rm build/DEBIAN/control build/usr/bin/doas-keepenv doas-keepenv_*-*_*.deb
	@-rm build/DEBIAN/control build/usr/bin/doas-keepenv doas-keepenv_*-*_*.deb 2> /dev/null
