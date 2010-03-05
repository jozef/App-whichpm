package App::whichpm;

=head1 NAME

App::whichpm - locate a Perl module and it's version

=head1 SYNOPSIS

	use App::whichpm 'which_pm';
	my ($filename, $version) = which_pm('App::whichpm');
	my $filename = App::whichpm::find('App::whichpm');

from shell:

	whichpm App::whichpm
	whichpm Universe::ObservableUniverse::Filament::SuperCluster::Cluster::Group::Galaxy::Arm::Bubble::InterstellarCloud::SolarSystem::Earth

=head1 DESCRIPTION

Loads a given module and reports it's location and version. 

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use Exporter 'import';
our @EXPORT_OK = qw(
    which_pm
);

=head1 EXPORTS

=head2 which_pm

same as L</find> only exported under C<which_pm> name.

=cut

*which_pm = *find;

=head1 FUNCTIONS

=head2 find($module_name)

Loads the C<$module_name>.

In scalar context returns filename coresponding to C<$module_name>.
In array context returns filename and version.

C<$module_name> can be either C<Some::Module::Name> or C<Some/Module/Name.pm>

=cut

sub find {
	my $module_name = shift;
	my $module_filename;
	
	if ($module_name =~ m/\.pm$/xms) {
		$module_filename = $module_name;
		$module_name     =~ s{/}{::};
		$module_name     = substr($module_name, 0, -3);
	}
	else {
		$module_filename = $module_name.'.pm';
		$module_filename =~ s{::}{/}xmsg;
	}
	
	eval "use $module_name;";
	my $filename = $INC{$module_filename};
	return if not $filename;
	
	if (wantarray) {
		my $version  = eval { $module_name->VERSION };
		return ($filename, (defined $version ? $version : ()));
	}

	return $filename
}

1;


__END__

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 AUTHOR

Jozef Kutej

=cut
