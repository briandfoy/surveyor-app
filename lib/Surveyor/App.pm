package Surveyor::App;
use strict;
use warnings;

use subs qw();
use vars qw($VERSION);

$VERSION = '0.11';

=head1 NAME

Surveyor::App - Run benchmarks from a package

=head1 SYNOPSIS

	use Surveyor::App;

=head1 DESCRIPTION

=over 4

=cut

=item run( PACKAGE, ITERATIONS, @ARGS )

=cut

sub run {
	my( $package, $iterations, @args ) = @_;
	$package->set_up( @args );
	my @subs = get_all_bench_( $package );

	my %hash = map {
		( s/\Abench_//r, \&{"${package}::$_"} )
		} get_all_bench_( $package );

	require Benchmark;
	my $results = Benchmark::timethese( $iterations, \%hash );

	$package->tear_down();
	}

=item test( PACKAGE, @ARGS )

=cut

sub test {
	my( $package, @args ) = @_;
	my @subs = get_all_bench_();
	my %results;

	$package->set_up( @args );
	foreach my $sub ( get_all_bench_( $package ) ) {
		my @return = $package->$sub();
		$results{$sub} = \@return;
		}
	$package->tear_down;

	use Test::More;
	
	subtest pairs => sub {
		my @subs = keys %results;
		foreach my $i ( 1 .. $#subs ) {
			my @sub_names = @subs[ $i - 1, $i ];
			my( $first, $second ) = @results{ @sub_names };
			local $" = " and ";
			is_deeply( $first, $second, "@sub_names match return values" );
			}
		};
	
	done_testing();
	}

=item get_all_bench_

=cut

sub get_all_bench_ {
	my( $package ) = @_;
	$package //= __PACKAGE__;

	my @subs = 
		grep /\Abench_/, 
		keys %{"${package}::"};
	}


=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in a Git repository that I haven't made public
because I haven't bothered to set it up. If you want to clone
it, just ask and we'll work something out.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2013, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
