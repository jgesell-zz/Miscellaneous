#!/usr/bin/env perl
#
#
use warnings;
use strict;
use autodie;
use DataBrowser qw(browse);



sub permute {
	my $bc = $_[0];
	my @permutations;
	my @cycle = qw(A C G T N);
	my $length = length($bc);
	my @letters = split "", $bc;
	for (my $i = 0; $i < $length; $i++) {
		my $before = "";
		my $after = "";
		if ($i > 0) {
			$before = substr($bc, 0, $i)
		}
		if ($i < ($length - 1)) {
			$after = substr($bc, $i+1, ($length - 1));
		}
		foreach my $letter (@cycle) {
			my $new = "$before"."$letter"."$after";
			if ($new eq $bc) {
				next;
			}
			push @permutations, $new;
		}
	}
	return (\@permutations);
}

my %fh;
my $barcodes = {};

open IN, "$ARGV[0]";
while (my $line = <IN>) {
	chomp $line;
	my @parts = split /\t/, $line;
	my $sample = $parts[0];
	open ($fh{"$sample.1"}, ">$sample.1.fq") or die "Unable to open file";
	open ($fh{"$sample.2"}, ">$sample.2.fq") or die "Unable to open file";
	my $barcode = $parts[1];
	my @permutations = @{permute($barcode)};
	$barcodes->{$barcode} = $sample;
	foreach my $permutation (@permutations) {
		$barcodes->{$permutation} = $sample;
	}
}
close IN;

browse $barcodes;

open READ1, "$ARGV[1]";
open READ2, "$ARGV[3]";
open BARCODES, "$ARGV[2]";
while ( defined(my $headR1 = <READ1>) && defined(my $headR2 = <READ2>) && defined(my $headB = <BARCODES>)) {
	chomp $headR1;
	chomp $headR2;
	chomp $headB;
	my $seqR1 = <READ1>;
	chomp $seqR1;
	my $spaceR1 = <READ1>;
	chomp $spaceR1;
	my $qualR1 = <READ1>;
	chomp $qualR1;
	my $lineR1 = "$headR1\n$seqR1\n$spaceR1\n$qualR1";
	my $seqR2 = <READ2>;
	chomp $seqR2;
	my $spaceR2 = <READ2>;
	chomp $spaceR2;
	my $qualR2 = <READ2>;
	chomp $qualR2;
	my $lineR2 = "$headR2\n$seqR2\n$spaceR2\n$qualR2";
	my @partsR1 = split / /, $headR1;
	my @partsR2 = split / /, $headR2;
	my @partsB = split / /, $headB;
	if (($partsR1[0] eq $partsR2[0]) && ($partsR1[0] eq $partsB[0])){
		my $barcode = <BARCODES>;
		chomp $barcode;
		$barcode = reverse($barcode);
	       	$barcode =~ tr/ACGT/TGCA/;
		if (exists $barcodes->{$barcode}){
			my $sample = $barcodes->{"$barcode"};
			#print STDERR "Writing to $sample files";
			print {$fh{"$sample.1"}} "$lineR1\n";
			print {$fh{"$sample.2"}} "$lineR2\n";
		}
	<BARCODES>;
	<BARCODES>;
	}
}
close READ1;
close READ2;
close BARCODES;
	
## put something in here to open read 1 and read 2 and index reads, then determine which sample it is via the barcodes hash, then print read 1 and read 2 to the right file handle ##
#Here are some hints:
#print {$fh->{"$sample.1"}} "$head1\n$seq1\n$space1\n$qual1\n";
#The line above prints the variables $head1 $seq1 $space1 and $qual1 to $sample's read 1 file
#
#my $sample = $barcodes->{$bc};
#The line above looks up the sample in the barcodes hash given a $bc


foreach my $filehandle (keys %fh) {
	close ($fh{$filehandle});
}
