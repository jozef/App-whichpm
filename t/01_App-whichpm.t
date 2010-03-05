#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 12;

use File::Spec;
use FindBin qw($Bin);
use lib File::Spec->catfile($Bin, 'lib');

BEGIN {
	use_ok ( 'App::whichpm', 'which_pm' ) or exit;
}

exit main();

sub main {
	my $acme_empty_filename     = File::Spec->catfile($Bin, 'lib', 'Acme', 'empty.pm');
	my $acme_non_empty_filename = File::Spec->catfile($Bin, 'lib', 'Acme', 'nonEmpty.pm');
	is(App::whichpm::find('Acme::empty'), $acme_empty_filename, 'Acme::empty');
	is_deeply(
		[ App::whichpm::find('Acme::empty') ],
		[ $acme_empty_filename ], 'Acme::empty (wantarray)'
	);
	is(App::whichpm::find('Acme::nonEmpty'), $acme_non_empty_filename, 'nonEmpty');
	is_deeply(
		[ App::whichpm::find('Acme::nonEmpty') ],
		[ $acme_non_empty_filename, '0.01' ], 'nonEmpty (wantarray)'
	);
	is(App::whichpm::find('Acme::nonExisting'), (), 'nonExisting');
	is(which_pm('Acme::nonExisting'), (), 'which_pm export');
	is_deeply(
		[ which_pm('Acme::nonEmpty') ],
		[ $acme_non_empty_filename, '0.01' ],
		'which_pm export (wantarray)'
	);

	# pass filename
	is(App::whichpm::find('Acme/nonEmpty.pm'), $acme_non_empty_filename, 'nonEmpty');
	
	# execute script
	my $whichpm_script = File::Spec->catfile($Bin, '..', 'script', 'whichpm');
	my $inc            = join(' ', map { '-I'.$_ } @INC);
	like(`$^X $inc $whichpm_script 2>&1`, qr/usage:/, 'no argv => usage');
	like(`$^X $inc $whichpm_script App::whichpm`, qr{App/whichpm.pm \s \d}xms, 'whichpm App::whichpm');
	like(`$^X $inc $whichpm_script Acme::nonExisting`, qr{^$}xms, 'whichpm Acme::nonExisting');
	
	return 0;
}

