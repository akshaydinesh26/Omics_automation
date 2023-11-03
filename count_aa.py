#!/usr/bin/python

from Bio import SeqIO
from Bio.SeqUtils.ProtParam import ProteinAnalysis
import sys
import pandas as pd

data_empty = []
index = []
head = []
if len(sys.argv) == 2:
 inp = sys.argv[1]
 for rec in SeqIO.parse(inp,"fasta"):
  x = ProteinAnalysis(str(rec.seq))
  dic = x.count_amino_acids()
  data_empty.append(dic.values())
  index.append(rec.id)
  head = dic.keys()
 df = pd.DataFrame(data_empty)
 df.index = index
 df.columns = head
 df.to_csv('amino_acid_count.csv', sep=',', encoding='utf-8')
else:
 print("error-input doesnt match","\n",
 "use as python count_aa.py protein.fasta")
