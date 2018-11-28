NAME = tobase

SOURCES = main.d to_base.d

OBJECTS = $(SOURCES:.d=.o)

DC = dmd
DFLAGS = -unittest
COMPILE.d = $(DC) $(DFLAGS) -c
D_OUTPUT_OPTION = -of=$@

%.o: %.d
	$(COMPILE.d) $(D_OUTPUT_OPTION) $<

all: $(NAME)

$(NAME): $(OBJECTS)
	dmd -of=$(NAME) $(OBJECTS)

clean:
	rm -f $(OBJECTS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.phony: all clean fclean re
