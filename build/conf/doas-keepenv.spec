Name:       doas-keepenv
Version:    $
Release:    !%{?dist}
Summary:    doas, but keeps env vars
License:    MIT
URL:        https://github.com/stas-badzi/doas-keepenv
BugURL:    https://github.com/stas-badzi/doas-keepenv/issues
Source:     https://github.com/stas-badzi/doas-keepenv/archive/refs/tags/$.tar.gz
Packager:   Stanisław Badziak <stasbadzi@gmail.com>
BuildArch:  noarch
BuildRequires: coreutils
Requires:   coreutils,opendoas

%description
A shell script for running the doas command with keeping environment variables

%prep
%autosetup

%build

%install
mkdir -p %{buildroot}/usr/bin/
install -m 755 doas-keepenv %{buildroot}/usr/bin

%files
/usr/bin/doas-keepenv

%changelog
* Sun May 4 2025 Stanisław Badziak <stasbadzi@gmail.com> - 1.0-1
- Initial package
