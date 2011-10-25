#!/usr/bin/perl

# trims fastq files (version 1.3 and +)
# at the 3' end when the quality is 'B'
# indicating 'do not use for analysis'
# assumes four lines per sequence
# does limited sanity checking
# takes the sequences from STDIN 
# and results to STDOUT
# see example data at the end

# Lex, June 2011
# lex.nederbragt@bio.uio.no

# no warrenty, use at your own risk

use strict;
use warnings;

my @lines = ();

while(<>){
	chomp;
	push @lines, $_;
	# collect four lines at a time
	if ($#lines == 3){
		&trim(@lines);
		@lines = ();
	}
}


sub trim{
	my ($head1, $bases, $head2, $qual) = @_;
	
	# sanity checks
	# start of header lines
	if (substr($head1,0,1) ne '@' | substr($head2,0,1) ne '+'){
		print STDERR "File does not appear to be a correct fastq file:\n";
		print STDERR "Can't find symbols '\@' and '+' on each first and third line\n";
		print STDERR "1st, '\@' header found: '$head1'\n";
		print STDERR "2nd, '+' header found: '$head2'\n";
		die;
	}
	# similar header lines
# suggestion for adjustment (untested):
	if (length (substr($head2,1)) > 1 && substr($head1,1) ne substr($head2,1)){
#	if (substr($head1,1) ne substr($head2,1)){
		print STDERR "File does not appear to be a correct fastq file:\n";
		print STDERR "the read identifiers for the two headers are not equal\n";
		print STDERR "1st header found: '$head1'\n";
		print STDERR "2nd header found: '$head2'\n";
		die;
	}
	
	# check that there are in fact on or more 'B's at the end of the qual line
	if ($qual =~ /(B+)$/){
		# remove read when entire qual line is 'B's
		return if length($qual) == length($1);
		# cut off the B's and the corresponding DNA bases
		$bases = substr($bases, 0, -length($1));
		$qual = substr($qual, 0, -length($1));
	}
	# output
	print join "\n", ($head1, $bases, $head2, $qual);
	print "\n";
}

# testdata below
__DATA__
@PCUS-319-EAS487_0004_FC:1:1:1581:1035#0/1
CTACGTCACGAATACTTCTTCCTTGACACGGTATCAACGCACTCCTATTTCATTTTGGAGGAAAGATCTTCTTCGAAACGTCCTCGCTTACGCGATCGCTCTTCAGTG
+PCUS-319-EAS487_0004_FC:1:1:1581:1035#0/1
fffbfcffccff_ffggggggfggggeggggdeggffeffggggggcggggggggagedggeggggdggaaffafdfedfgfggggggggggfgcaefedfgcfcgdg
@PCUS-319-EAS487_0004_FC:1:1:1377:1028#0/1
AATGACAAATCACTCCATCCTTCTTCTCGTCGTCGTCGTTCGGCAGCCGTGACGGCCGAAGAGGAATTGCCAGCCGGAGAGACAATAGCATCGGCATCCCATTCTCCT
+PCUS-319-EAS487_0004_FC:1:1:1377:1028#0/1
ccfcccf_fddcfffccffafggeggfggaffcf^^^d_^ff]_afdd]bfadcdaadaa`K``Yc_cccddc_dfa[f_cac`_ccadaBBBBBBBBBBBBBBBBBB
@PCUS-319-EAS487_0004_FC:1:1:4694:1034#0/1
GGAATTCTAAATCTGGAATTTCAATCCAAAATGAATACCATAGGTGGTGATGTTTTGGCTGGATTAAATAAAGCTATTGACATTGCTGAAAAAGATTTTCAGCGCTTG
+PCUS-319-EAS487_0004_FC:1:1:4694:1034#0/1
cffWffffdfffcdfdfdfffddfffffffdcfffdffffabdd`^aWcaf_ffdccfdfffffffffffcccfafcfffffff[f[fcfefdfccdfdfBBBBBBBB
@PCUS-319-EAS487_0004_FC:1:1:4760:1030#0/1
CACCCACATTGGCGAGATGCCCAACAGTGAGCCCGTAGAGTCGATCTCCGCTCTTAATGACGAAACTCAAGGTACAGCCGCCTCCATCTTGGTTCAAGACCCAATCGC
+PCUS-319-EAS487_0004_FC:1:1:4760:1030#0/1
hhhdhhhggdffhhfegcghhhghhggcgfdhhffcffffaecbadddg_edffddcfdhefdfedfffdca_dcdagddfddfdddfdcdd_cddccadddfdcfcf
@PCUS-319-EAS487_0004_FC:1:1:7977:1034#0/1
ATGACCAGGCATGCAATAGTGGCTGTTGAAACAGTCTTGACAAAGACTTCCAATCGCTTGCGTCTTTCTTTCTTTTCTGCTGAAGCATAAATTTTTTCAGCCATCCTT
+PCUS-319-EAS487_0004_FC:1:1:7977:1034#0/1
ghhhhhfghfdfghhhhhghgdhghY_Y^a^W\WZ[X\I[X\]\LWWWZT`[^W\X_^_^\^NY]`bJ^]`Xb``c[`X[[TQZ[V^[\^\W`^``\QY\_`[^_BBB
@PCUS-319-EAS487_0004_FC:1:1:18964:1030#0/1
TGATTTGTGATTGCTGACTTTGAGCAATGTTCTTTGACGGAAAGTGATATTGGTGGCGGTGGCAGAGGCAATGGCTTGAAGAAACTGTCCCAAACCACGAACCGTGGC
+PCUS-319-EAS487_0004_FC:1:1:18964:1030#0/1
ffdffffdfdghhdhhffhhhhcgdddhhegdhhggddgg_aaf_eadddggfbgdaed`ca_aa]ddaaaadb]acd\_`Y^_Uaa__a^I`^]__\aBBBBBBBBB
@PCUS-319-EAS487_0004_FC:1:1:1316:931#0/1
NGCGCAGGTTACAACAAGAACTGGATCTTCATTTGCATTGCCAAACCATGGGCAAAGCTCAATTGGAAGACTGTCATTCAAAGCATTCCGATGCAGATAAACAGATCG
+PCUS-319-EAS487_0004_FC:1:1:1316:931#0/1
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
