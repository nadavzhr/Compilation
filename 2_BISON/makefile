# Compiler and flags
CC = gcc
CFLAGS = -Wall -g

# Bison and Lex files
BISON_FILE = part2.y
LEX_FILE = part2.lex

# Helper files
HELPER_FILE = part2_helpers.c

# Generated files
BISON_C = part2.tab.c
BISON_H = part2.tab.h
LEX_C = lex.yy.c

# Output executable
TARGET = part2

# Default rule
all: $(TARGET)

# Rule to build the executable
$(TARGET): $(BISON_C) $(LEX_C) $(HELPER_FILE)
	$(CC) $(CFLAGS) -o $(TARGET) $(BISON_C) $(LEX_C) $(HELPER_FILE)

# Rule to generate Bison files
$(BISON_C) $(BISON_H): $(BISON_FILE)
	bison -d $(BISON_FILE)

# Rule to generate Lex files
$(LEX_C): $(LEX_FILE) $(BISON_H)
	flex $(LEX_FILE)

# Clean up generated and compiled files
clean:
	rm -f $(BISON_C) $(BISON_H) $(LEX_C) $(TARGET)

# Phony targets
.PHONY: all clean
