CC = g++
#The -Ofast might not work with older versions of gcc; in that case, use -O2
CFLAGS = -lm -pthread -Ofast -march=native -Wall -funroll-loops -Wno-unused-result

OBJS = EvaluationPP.o Paraphrase.o

PROG = word2vec_joint word2vec_join_thread word2vec_pretrain directed_RCM tune_lm eval
all: $(PROG)

%.o : %.cpp
	$(CC) -c $< -o $@ $(CFLAGS)

word2vec_joint : word2vec_joint.cpp $(OBJS)
	$(CC) word2vec_joint.cpp $(OBJS) -o word2vec_joint $(CFLAGS)


word2vec_join_thread : word2vec_join_thread.cpp $(OBJS)
	$(CC) word2vec_join_thread.cpp $(OBJS) -o word2vec_join_thread $(CFLAGS)

word2vec_pretrain : word2vec_pretrain.cpp $(OBJS)
	$(CC) word2vec_pretrain.cpp $(OBJS) -o word2vec_pretrain $(CFLAGS)

directed_RCM : directed_RCM.cpp Paraphrase_directed.o
	$(CC) directed_RCM.cpp Paraphrase_directed.o -o directed_RCM $(CFLAGS)


tune_lm : tune_lm.cpp $(OBJS)
	$(CC) tune_lm.cpp $(OBJS) -o tune_lm $(CFLAGS)

eval : eval.cpp $(OBJS)
	$(CC) eval.cpp $(OBJS) -o eval $(CFLAGS)

clean:
	rm -rf $(PROG) *.o
