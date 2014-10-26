package Crypt::SSLeay;

use strict;
use vars qw(@ISA $VERSION %CIPHERS);

require DynaLoader;

@ISA = qw(DynaLoader);
$VERSION = '0.16';

bootstrap Crypt::SSLeay $VERSION;

use vars qw(%CIPHERS);
%CIPHERS = (
   'NULL-MD5'     => "No encryption with a MD5 MAC",
   'RC4-MD5'      => "128 bit RC4 encryption with a MD5 MAC",
   'EXP-RC4-MD5'  => "40 bit RC4 encryption with a MD5 MAC",
   'RC2-CBC-MD5'  => "128 bit RC2 encryption with a MD5 MAC",
   'EXP-RC2-CBC-MD5' => "40 bit RC2 encryption with a MD5 MAC",
   'IDEA-CBC-MD5' => "128 bit IDEA encryption with a MD5 MAC",
   'DES-CBC-MD5'  => "56 bit DES encryption with a MD5 MAC",
   'DES-CBC-SHA'  => "56 bit DES encryption with a SHA MAC",
   'DES-CBC3-MD5' => "192 bit EDE3 DES encryption with a MD5 MAC",
   'DES-CBC3-SHA' => "192 bit EDE3 DES encryption with a SHA MAC",
   'DES-CFB-M1'   => "56 bit CFB64 DES encryption with a one byte MD5 MAC",
);


# A xsupp bug made this nessesary
sub Crypt::SSL::CTX::DESTROY  { shift->free; }
sub Crypt::SSL::Conn::DESTROY { shift->free; }

1;

__END__

=head1 NAME

  Crypt::SSLeay - OpenSSL & SSLeay glue that provides LWP https support

=head1 SYNOPSIS

  lwp-request https://www.nodeworks.com

=head1 DESCRIPTION

This perl module provides support for the https
protocol under LWP, so that a LWP::UserAgent can 
make https GET & HEAD requests. 

The Crypt::SSLeay package contains Net::SSL,
which is automatically loaded by LWP::Protocol::https
on https requests, and provides the necessary SSL glue
for that module to work via these deprecated modules:

   Crypt::SSLeay::CTX
   Crypt::SSLeay::Conn
   Crypt::SSLeay::X509

Work on Crypt::SSLeay has been continued only to
provide https support for the LWP - libwww perl
libraries.  If you want access to the OpenSSL 
API via perl, check out Sampo's Net::SSLeay.

=head1 INSTALL

=head2 OpenSSL

You must have OpenSSL or SSLeay installed before compiling 
this module.  You can get the latest OpenSSL package from:

  http://www.openssl.org

When installing openssl make sure your config looks like:

  > ./config --openssldir=/usr/local/openssl
 or
  > ./config --openssldir=/usr/local/ssl

 then
  > make
  > make test
  > make install

This way Crypt::SSLeay will pick up the includes and 
libraries automatically.  If your includes end up
going into a separate directory like /usr/local/include,
then you will need to symlink /usr/local/openssl/include
to /usr/local/include

=head2 Crypt::SSLeay

The latest Crypt::SSLeay can be found at your nearest CPAN,
and also:

  http://www.perl.com/CPAN-local/modules/by-module/Crypt/

Once you have downloaded it, Crypt::SSLeay installs easily 
using the make or nmake commands as shown below.  

  > perl Makefile.PL
  > make
  > make test
  > make install

  * use nmake for win32

=head1 COMPATIBILITY

 This module has been compiled on the following platforms:

 PLATFORM	CPU 	SSL		PERL	 DATE		WHO
 --------	--- 	---		----	 ----		---
 WinNT SP4 	x86	OpenSSL 0.9.4	5.00404	 1999-10-03	Joshua Chamas
 FreeBSD 3.2	?x86	OpenSSL 0.9.2b	5.00503	 1999-09-29	Rip Toren
 Solaris 2.6	?Sparc	OpenSSL 0.9.4	5.00404	 1999-08-24	Patrick Killelea
 FreeBSD 2.2.5	x86	OpenSSL 0.9.3	5.00404	 1999-08-19	Andy Lee
 Solaris 2.5.1	USparc	OpenSSL 0.9.4	5.00503	 1999-08-18	Marek Rouchal
 Solaris 2.6	x86	OpenSSL 0.9.4	5.00501	 1999-08-12	Joshua Chamas	
 Solaris 2.6	x86	SSLeay 0.8.0	5.00501	 1999-08-12	Joshua Chamas	
 Linux 2.2.10	x86 	OpenSSL 0.9.4	5.00503	 1999-08-11	John Barrett
 WinNT SP4	x86	SSLeay 0.9.2	5.00404	 1999-08-10	Joshua Chamas

=head1 BUILD NOTES

=head2 Solaris - Symbol Error: __umoddi3 : referenced symbol not found

 Problem:

On Solaris x86, the default PERL configuration, and preferred, is to use
the ld linker that comes with the OS, not gcc.  Unfortunately during the 
OpenSSL build process, gcc generates in libcrypto.a, from bn_word.c,
the undefined symbol __umoddi3, which is supposed to be later resolved
by gcc from libgcc.a

The system ld linker does not know about libgcc.a by default, so 
when building Crypt::SSLeay, there is a linker error for __umoddi3

 Solution:

The fix for this symlink your libgcc.a to some standard directory
like /usr/local/lib, so that the system linker, ld, can find
it when building Crypt::SSLeay.  

=head2 FreeBSD 2.x.x / Solaris - ... des.h:96 #error _ is defined ...

If you encounter this error: "...des.h:96: #error _ is
defined, but some strange definition the DES library cannot handle
that...," then you need to edit the des.h file and comment out the 
"#error" line.

Its looks like this error might be common to other operating
systems, and that occurs with OpenSSL 0.9.3.  Upgrades to
0.9.4 seem to fix this problem.

=head1 NOTES

Many thanks to Gisle Aas for the original writing of 
this module and many others including libwww for perl.  
The web will never be the same :)

=head1 SUPPORT

For OpenSSL support, please email the openssl user
mailing list at openssl-users@openssl.org  

Please send any Crypt::SSLeay questions or comments to 
me at joshua@chamas.com

This module was originally written by Gisle Aas, and I am
now maintaining it.

=head1 COPYRIGHT

 Copyright (c) 1999 Joshua Chamas.
 Copyright (c) 1998 Gisle Aas.

This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself. 

=cut
