BIN=aoc2021
TARGET=aoc_2021_nim
ARGS=-v $(shell pwd):/aoc

format:
	nimpretty aoc2021.nim solutions/*.nim

build:
	docker build --tag ${TARGET} .

all: build
	docker run -it --rm ${ARGS} ${TARGET} all

day: build
	docker run -it --rm ${ARGS} ${TARGET} day --number ${DAY}

help: build
	docker run -it --rm ${TARGET} --help

clean:
	rm ${BIN}
