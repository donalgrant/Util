package Util::Math;

use strict;
use POSIX qw(acos atan);

BEGIN {
  use Exporter ();
  our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

  $VERSION = sprintf "%d.%03d", q$Revision:  1.1 $ =~ /(\d+)/g;

  @ISA    = qw(Exporter);
  @EXPORT = qw(&msg &fmod &sphere2rect &dot_product &polar_dist &d2r &r2d);
}

my $PI=4.0*atan(1.0);
my $DEG2RAD=180.0/$PI;

sub d2r { return shift()/$DEG2RAD }
sub r2d { return shift()*$DEG2RAD }

# replace this with my standard diagnostic messaging later

sub msg {
  print @_,"\n";
}

# floating point modulo function
# (assumes $m>0)

# could possibly use POSIX fmod

sub fmod {
  my $x=shift;
  my $m=shift;
  return $x-$m*int($x/$m) if $x>=0.0;
  return $x+$m*(1+int(abs($x)/$m));
}

sub sphere2rect {
  my $p=shift;
  my $theta=shift;
  my $phi=shift;
  return ($p*sin($theta)*cos($phi),$p*sin($theta)*sin($phi),$p*cos($theta));
}

sub dot_product {
  my $x1=shift;
  my $x2=shift;
  die "vector size mismatch @{[ scalar(@$x1) ]} != @{[ scalar(@$x2) ]}"
    unless scalar(@$x1)==scalar(@$x2);
  my $sum=0.0;
  for (0..scalar(@$x1)-1) { $sum += $x1->[$_]*$x2->[$_] }
  return $sum;
}

# to get the angular distance between two pointing directions 
# (all input units in degs)
# convert both to rectangular (unit) vectors, and get the
# angle between them from the dot product

sub polar_dist {
  my $phi1=d2r(shift());
  my $theta1=d2r(90.0-shift());
  my $phi2=d2r(shift());
  my $theta2=d2r(90.0-shift());
  my @n1=sphere2rect(1.0,$theta1,$phi1);
  my @n2=sphere2rect(1.0,$theta2,$phi2);
  return r2d(acos(dot_product(\@n1,\@n2)));
}

1;
