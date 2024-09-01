CXX = g++
CXXFLAGS = -g -w -std=c++17  # Suppress all warnings
# Edit out -Wno-return-type before submission
# Just included to ignore warnings about missing return statements for m2 functions

CC = gcc
CFLAGS = -g -w -std=gnu11  # Suppress all warnings

CXX_SRCS = bigint.cpp bigint_tests.cpp
CXX_OBJS = $(CXX_SRCS:.cpp=.o)

C_SRCS = tctest.c
C_OBJS = $(C_SRCS:.c=.o)

# Rule for compiling .cpp files into .o files
%.o : %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule for compiling .c files into .o files
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link object files to create the final executable
bigint_tests : $(CXX_OBJS) $(C_OBJS)
	$(CXX) -o $@ $(CXX_OBJS) $(C_OBJS)

.PHONY: solution.zip
solution.zip : $(CXX_SRCS) $(C_SRCS) *.h README.txt
	rm -f $@
	zip -9r $@ $(CXX_SRCS) $(C_SRCS) *.h README.txt

clean :
	rm -f bigint_tests *.o

# Generate header file dependencies
depend :
	$(CXX) $(CXXFLAGS) -M $(CXX_SRCS) > depend.mak
	$(CC) $(CFLAGS) -M $(C_SRCS) >> depend.mak

depend.mak :
	touch $@

include depend.mak
