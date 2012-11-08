package Util::AstroCoords;

use strict;
use POSIX qw(acos atan pow);
use Util::Math;
use Astro::Coord;
use Astro::Time;

BEGIN {
  use Exporter ();
  our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

  $VERSION = sprintf "%d.%03d", q$Revision:  1.1 $ =~ /(\d+)/g;

  @ISA    = qw(Exporter);
  @EXPORT = qw(&dist &target_azel_at_lst &airmass_at_el);
}

=head1 SYNOPSIS

  use Util::AstroCoords;
  my $d=dist($ra1,$dec1,$ra2,$dec2);  # ra in decimal hrs, dec in decimal degs

=cut

sub dist {
  my ($ra1,$dd1,$ra2,$dd2)=@_;
  my ($rad1,$dec1)=( d2r($ra1*15.0), d2r($dd1) );  # ra is decimal hrs, dd is dec in decimal degs
  my ($rad2,$dec2)=( d2r($ra2*15.0), d2r($dd2) );  # rad,dec in radians
  return r2d(acos(sin($dec1)*sin($dec2)+cos($dec1)*cos($dec2)*cos($rad1-$rad2))); # result in dec degs
}

# target_azel_at_lst($ra,$dec,$lat,$time)
# returns azimuth, elevation in degrees of a target at
# coords RA and DEC from an observing latitude LAT in deg
# at local sidereal time $time in hours

sub target_azel_at_lst {
  my $ra=shift;
  my $dec=shift;
  my $lat=shift;
  my $lst=shift;
  my $ha=$ra-$lst;
  return map { turn2deg($_) } eqazel($ha/24.0,deg2turn($dec),deg2turn($lat));
}

# return the fractional airmass at a given elevation angle in degrees
# using an improved approximation to account for earth curvature, from
# http://en.wikipedia.org/wiki/Air_mass_(astronomy)#CITEREFPickering2002

sub airmass_at_el {
  my $h=shift;  # use elevation as apparent altitude
  my $arg=$h+244.0/(165.0+47.0*pow($h,1.1));
  return 1.0/sin(d2r($arg));
}

1;
