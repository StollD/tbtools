V ?= v
CC ?= gcc
TARGET ?= tb

all:
	$(V) -cc $(CC) -o $(TARGET) -prod .

fmt:
	$(V) fmt -w *.v

clean:
	rm $(TARGET)
