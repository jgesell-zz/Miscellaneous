#!/usr/bin/env perl

use warnings;
use strict;
#use DataBrowser qw(browse);
use Statistics::Basic qw(:all);

my $in;
if ($ARGV[0]) {
	$in = $ARGV[0]
} else {
	$in = "-";

}
open IN, "$in";

#my $min= 100000000000000000;
my $min = "inf";
my $max = 0;
my @numbers;
my $total = 0;
while (my $line = <IN>) {
	
	chomp $line;
	#unless (defined($line)) {
	unless(defined($line)){
		next
	}
	push @numbers, $line;
	if ($line < $min) {
		$min = $line;
	}
	if ($line > $max) {
		$max = $line;
	}
	$total = $total + $line;
}
my $count = scalar(@numbers);
my $median = median(\@numbers);
$median =~ s/,//g;
my $avg = ($total/$count);
my $underRoot = 0;
foreach my $num (@numbers) {
	my $pre = ($num - $avg) ** 2;
	$underRoot = $underRoot + $pre;

}
my $stddev = sqrt(($underRoot/$count));
my $covar = $stddev / $avg;
print "Count: $count\n";
print "Total: $total\n";
print "Min: $min\n";
print "Max: $max\n";
print "Mean: $avg\n";
print "Med: $median\n";
print "StdDev: $stddev\n";
print "CoV: $covar\n";
