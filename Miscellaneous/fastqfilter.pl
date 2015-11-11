#!/usr/bin/env perl
#
#
use warnings;
use strict;

my $reverse = 0;
if ($ARGV[0] eq "-v") {
	$reverse = shift @ARGV;
}


my $headers = "$ARGV[0]";
my %headers;
open IN, "$headers";

while (my $line = <IN>) {
	chomp $line;
	$headers{$line} = 1;
}
close IN;

open IN, "-";
my $spaceQr = qr/ .*/;
while (my $head = <IN>) {
	chomp $head;
	my $reverse = reverse($head);
	chop $reverse;
	$head = reverse($reverse);

	my $seq = <IN>;
	my $space = <IN>;
	my $qual = <IN>;
	my $alternate = $head;
	$alternate =~ s/$spaceQr//;
	unless ($reverse) {
		if (exists $headers{$head} or exists $headers{$alternate}) {
			print "\@$head\n";
			print "$seq";
			print "$space";
			print "$qual";
		}
	} else {
		unless (exists $headers{$head} or exists $headers{$alternate}) {
			print "\@$head\n";
			print "$seq";
			print "$space";
			print "$qual";	
		}
	}

}



