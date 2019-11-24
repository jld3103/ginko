Name: ginko
Version: 1.2.0+10
Release: 1.2.0+10
Summary: The Ginko app
License: FIXME

%description
The Ginko app

%install
mkdir -p $RPM_BUILD_ROOT%{_bindir}
mkdir -p $RPM_BUILD_ROOT/usr/lib/ginko
mkdir -p $RPM_BUILD_ROOT%{_datadir}/applications
cp -r $RPM_BUILD_DIR $RPM_BUILD_ROOT
chmod 0755 $RPM_BUILD_ROOT%{_bindir}/ginko
chmod 0755 $RPM_BUILD_ROOT%{_datadir}/applications/ginko.desktop

%files
%{_bindir}/ginko
/usr/lib/ginko/
%{_datadir}/applications/ginko.desktop