# by Nick Loman

from Bio import SeqIO
import sys

class Manifest:
        def __init__(self, cols):
                self.id = cols[0]
                self.path = cols[1]
                self.extra = cols[2:]

def read_manifest(fn):
        samples = []
        for ln in open(fn):
                if ln.startswith('#'):
                        continue
                cols = ln.rstrip().split("\t")
                samples.append(Manifest(cols))
        return samples

def stats(seq_name, fh):
        contig_lengths = [len(rec) for rec in SeqIO.parse(fh, "fasta") if len(rec) >= MIN_LENGTH]
        contig_lengths.sort(reverse=True)
        print "\n".join([seq_name + "\t" + str(l) for l in contig_lengths])

MIN_LENGTH = 0
#if len(sys.argv) == 3:
#        MIN_LENGTH = int(sys.argv[2])
#samples = read_manifest(sys.argv[1])
for s in sys.argv[1:]:
        stats(s, open(s))

