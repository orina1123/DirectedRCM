CC = g++
#The -Ofast might not work with older versions of gcc; in that case, use -O2
CFLAGS = -lm -lpthread -Ofast -march=native -Wall -funroll-loops -Wno-unused-result

OBJS = EvaluationPP.o Paraphrase.o

PROG = word2vec_joint word2vec_join_thread tune_lm eval
all: $(PROG)

%.o : %.cpp
	$(CC) -c $< -o $@ $(CFLAGS)

word2vec_joint : word2vec_joint.cpp $(OBJS)
	$(CC) word2vec_joint.cpp $(OBJS) -o word2vec_joint $(CFLAGS)

word2vec_join_thread : word2vec_join_thread.cpp $(OBJS)
	$(CC) word2vec_join_thread.cpp $(OBJS) -o word2vec_join_thread $(CFLAGS)

tune_lm : tune_lm.cpp $(OBJS)
	$(CC) tune_lm.cpp $(OBJS) -o tune_lm $(CFLAGS)

eval : eval.cpp $(OBJS)
	$(CC) eval.cpp $(OBJS) -o eval $(CFLAGS)

clean:
	rm -rf $(PROG) *.o
