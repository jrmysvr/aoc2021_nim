from nimlang/nim:latest

WORKDIR /aoc
RUN nimble install -y cligen argparse

ENTRYPOINT ["nim",  "c",  "-r",  "aoc2021.nim"]
