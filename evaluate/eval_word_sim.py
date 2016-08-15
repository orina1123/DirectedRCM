#-*- encoding: UTF-8 -*-

import sys
import codecs
import re
import argparse
import numpy as np
import gensim
from scipy.spatial import distance
from scipy.stats import spearmanr
from nltk.corpus import wordnet as wn

# settings
ap = argparse.ArgumentParser()
ap.add_argument("vec_file", type=str)
ap.add_argument("test_file", type=str)
ap.add_argument("-f", "--vec-format", default="word2vec_bin", type=str, help="type of embedding model {word2vec_bin, word2vec_txt, gensim}")
ap.add_argument("-s", "--sense-expand", default=None, type=str, choices=[None, 'first', 'closest', 'weighted'], help="")
args = ap.parse_args()

# load word embedding model
if args.vec_format == "word2vec_bin":
        model = gensim.models.Word2Vec.load_word2vec_format(args.vec_file, binary=True)
elif args.vec_format == "word2vec_txt":
        model = gensim.models.Word2Vec.load_word2vec_format(args.vec_file)
elif args.vec_format == "gensim":
        model = gensim.models.Word2Vec.load(args.vec_file)

# read word similarity data
ans = []
pred = []
n_OOV_pair = 0
with codecs.open(args.test_file, "r", "utf-8") as f:
        for line in f:
                parts = re.split(r"\s+", line.strip())
                #print parts
                _w1, _w2, score = parts[0].lower(), parts[1].lower(), float(parts[2])
                #print w1, w2, score
                
                flag = False

                w1, w2 = _w1, _w2
                if args.sense_expand == "first":
                    syn1 = wn.synsets(_w1)
                    if len(syn1) > 0:
                        sense1 = syn1[0].name()
                        if sense1 in model:
                            w1 = sense1
                    syn2 = wn.synsets(_w2)
                    if len(syn2) > 0:
                        sense2 = syn2[0].name()
                        if sense2 in model:
                            w2 = sense2 
                    
                    if w1 not in model:
                        print "[OOV]", _w1, w1
                        flag = True
                    if w2 not in model:
                        print "[OOV]", _w2, w2
                        flag = True
                    if not flag:
                        best_sim = model.similarity(w1, w2)

                elif args.sense_expand == "closest":
                    syn1 = wn.synsets(_w1)
                    syn2 = wn.synsets(_w2)
                    best_sim = -1
                    flag = True
                    for s1 in map(lambda syn: syn.name(), syn1):
                        for s2 in map(lambda syn: syn.name(), syn2):
                            if s1 in model and s2 in model:
                                sim = model.similarity(s1, s2)
                                if sim > best_sim:
                                    flag = False
                                    best_sim = sim

                elif args.sense_expand == None:
                    if w1 not in model:
                        print "[OOV]", _w1, w1
                        flag = True
                    if w2 not in model:
                        print "[OOV]", _w2, w2
                        flag = True
                    if not flag:
                        best_sim = model.similarity(w1, w2)

                #TODO other methods of calculating similarity score
                if flag: 
                    print "--skipped--", _w1, _w2, score
                    n_OOV_pair += 1
                else:
                    ans.append(score)
                    pred.append(best_sim)
                   
cor = spearmanr(ans, pred)[0]
print "Spearman rank-order correlation coefficient:", cor

print "sequence length: %d" % len(ans)
print "%d pairs have some word not in the model" % n_OOV_pair

