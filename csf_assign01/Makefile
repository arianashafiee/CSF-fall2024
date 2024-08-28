CXX = g++
CXXFLAGS = -g -Wall -std=c++17 
# edit out -Wno-return-type before submission
#just included to ignore warnings about missing return statements for m2 functions
CC = gcc
CFLAGS = -g -Wall -std=gnu11

CXX_SRCS = bigint.cpp bigint_tests.cpp
CXX_OBJS = $(CXX_SRCS:.cpp=.o)

C_SRCS = tctest.c
C_OBJS = $(C_SRCS:.c=.o)

%.o : %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

bigint_tests : $(CXX_OBJS) $(C_OBJS)
	$(CXX) -o $@ $(CXX_OBJS) $(C_OBJS)

.PHONY: solution.zip
solution.zip :
	rm -f $@
	zip -9r $@ *.c *.cpp *.h README.txt

clean :
	rm -f bigint_tests *.o

# Generate header file dependencies
depend :
	$(CXX) $(CXXFLAGS) -M $(CXX_SRCS) > depend.mak
	$(CC) $(CFLAGS) -M $(C_SRCS) >> depend.mak

depend.mak :
	touch $@

include depend.mak
