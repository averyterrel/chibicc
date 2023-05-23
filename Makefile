include config.mk

.c.o:
	$(CC) -o $@ -c $< $(CFLAGS)

stage1: $(OBJ)
	$(CC) -o chibicc $(OBJ) $(CFLAGS) $(LDFLAGS)
stage2: $(STAGETWO_OBJ)
	./chibicc -o stage2/chibicc $(OBJ) $(CFLAGS) $(LDFLAGS)

test1: chibicc
	$(MAKE) -C test/
test2: stage2/chibicc
	$(MAKE) -C stage2/test/

clean:
	rm -rf chibicc stage2
	rm -f `find . -type f '(' -name '*.o' -o -name '*~' ')'`
ifdef TEST
	$(MAKE) -C tests/ clean
endif


ifdef STAGETWO
ifdef TEST
all: clean stage1 test1 stage2 test2
else
all: clean stage1 stage2
endif
else
ifdef TEST
all: clean stage1 test1
else
all: clean stage1
endif
endif

.PHONY: all
