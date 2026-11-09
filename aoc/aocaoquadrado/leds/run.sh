#!/bin/sh
# Simula no terminal o programa leds.asm rodando no SoC (../top.sv)
# Uso: cd leds && sh run.sh
set -e
CROSS=riscv64-unknown-elf
$CROSS-as -march=rv32i -o leds.o leds.asm
$CROSS-ld -m elf32lriscv -T ../tests/riscv.ld -o leds.elf leds.o
$CROSS-objcopy -O verilog --verilog-data-width=4 leds.elf riscv.hex
iverilog -g2012 -s test ../top.sv ../riscvmulti.sv ../dec7seg.sv ../tests/mem.sv test.sv
vvp a.out
