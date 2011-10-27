#!/usr/bin/env python

# based on this SeqAnswers thread
# http://seqanswers.com/forums/showthread.php?t=6140
# original written by Peter Cock
 

from Bio import SeqIO #Biopython 1.54 or later needed
import sys

#######################################################
#
# Change the following settings to suit your needs
#

if len(sys.argv) != 5:
	print "Usage: interleave_pairs.py read_1_fastq_file read2_fastq_file output_pairs orphan_reads"
	raise SystemExit

input_forward_filename = sys.argv[1]
input_reverse_filename = sys.argv[2] 

output_pairs_filename = sys.argv[3]
output_orphan_filename = sys.argv[4] 

f_suffix = "/1"
r_suffix = "/2"

#######################################################

if f_suffix:
    f_suffix_crop = -len(f_suffix)
    def f_name(name):
        """Remove the suffix from a forward read name."""
        assert name.endswith(f_suffix), name
        return name[:f_suffix_crop]
else:
    #No suffix, don't need a function to fix the name
    f_name = None

if r_suffix:
    r_suffix_crop = -len(r_suffix)
    def r_name(name):
        """Remove the suffix from a reverse read name."""
        assert name.endswith(r_suffix), name
        return name[:r_suffix_crop]
else:
    #No suffix, don't need a function to fix the name
    r_name = None
    
print "Indexing forward file..."
forward_dict = SeqIO.index(input_forward_filename, "fastq", key_function=f_name)

print "Indexing reverse file..."
reverse_dict = SeqIO.index(input_reverse_filename, "fastq", key_function=r_name)

print "Ouputing pairs and forward orphans..."
pair_handle = open(output_pairs_filename, "w")
orphan_handle = open(output_orphan_filename, "w")
for key in forward_dict:
    if key in reverse_dict:
         pair_handle.write(forward_dict.get_raw(key))
         pair_handle.write(reverse_dict.get_raw(key))
    else:
         orphan_handle.write(forward_dict.get_raw(key))
pair_handle.close()
print "Ouputing reverse orphans..."
for key in reverse_dict:
    if key not in forward_dict:
         orphan_handle.write(reverse_dict.get_raw(key))
orphan_handle.close()
print "Done"
