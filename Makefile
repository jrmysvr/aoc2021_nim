BIN=aoc2021
BUILD=build/
TARGET=aoc_2021_nim
ARGS=-v $(shell pwd):/aoc -v $(shell pwd)/build:/aoc/build

format:
	nimpretty aoc2021.nim solutionsPkg/*.nim

build:
	docker build --tag ${TARGET} .

all: build
	docker run -it --rm ${ARGS} ${TARGET} \
		nim c \
		-r ${BIN} all

day: build
	docker run -it --rm ${ARGS} ${TARGET} \
		nim c \
		--outDir=/aoc/build \
		-r solutionsPkg/day${DAY}.nim

help: build
	docker run -it --rm ${TARGET} --help

clean:
	rm -rf ${BIN} ${BUILD}
