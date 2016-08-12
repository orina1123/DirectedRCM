CC = g++
#The -Ofast might not work with older versions of gcc; in that case, use -O2
CFLAGS = -lm -pthread -Ofast -march=native -Wall -funroll-loops -Wno-unused-result

OBJS = EvaluationPP.o Paraphrase.o

PROG = word2vec_save_both word2vec_joint orig_RCM directed_RCM sep_in_out_emb eval
all: $(PROG)

%.o : %.cpp
	$(CC) -c $< -o $@ $(CFLAGS)

word2vec_save_both : word2vec_save_both.c $(OBJS)
	$(CC) word2vec_save_both.c $(OBJS) -o word2vec_save_both $(CFLAGS)

word2vec_joint : word2vec_joint.cpp $(OBJS)
	$(CC) word2vec_joint.cpp $(OBJS) -o word2vec_joint $(CFLAGS)

orig_RCM : orig_RCM.cpp $(OBJS)
	$(CC) orig_RCM.cpp $(OBJS) -o orig_RCM $(CFLAGS)

directed_RCM : directed_RCM.cpp Paraphrase_directed.o
	$(CC) directed_RCM.cpp Paraphrase_directed.o -o directed_RCM $(CFLAGS)

sep_in_out_emb : sep_in_out_emb.cpp 
	$(CC) sep_in_out_emb.cpp -o sep_in_out_emb $(CFLAGS)

#tune_lm : tune_lm.cpp $(OBJS)
#	$(CC) tune_lm.cpp $(OBJS) -o tune_lm $(CFLAGS)

eval : eval.cpp $(OBJS)
	$(CC) eval.cpp $(OBJS) -o eval $(CFLAGS)

clean:
	rm -rf $(PROG) *.o
