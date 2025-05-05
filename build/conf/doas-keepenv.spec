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
mkdir -p %{buildroot}/usr/bin/ %{buildroot}/usr/share/licenses/doas-keepenv %{buildroot}/usr/share/doc/doas-keepenv
install -m 755 doas-keepenv %{buildroot}/usr/bin
install -Dm644 LICENSE %{buildroot}/usr/share/licenses/doas-keepenv
install -Dm644 README.md %{buildroot}/usr/share/doc/doas-keepenv

%files
/usr/bin/doas-keepenv
/usr/share/licenses/doas-keepenv/LICENSE
/usr/share/doc/doas-keepenv/README.md

%changelog
* Sun May 4 2025 Stanisław Badziak <stasbadzi@gmail.com> - 1.0-1
- Initial package
