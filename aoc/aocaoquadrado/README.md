# RISC-V multiciclo: LEDs com botão

Programa em *assembly* que roda no processador RISC-V multiciclo e acende um LED por vez, indo do `Led9` ao `Led0` e voltando. Ao apertar o botão `KEY[1]`, a sequência volta ao início (`Led9`).

## Arquivos

Tudo fica em `aoc/aocaoquadrado`:

| Arquivo | O que é |
|---|---|
| `riscvmulti.sv` | Processador RISC-V multiciclo |
| `top.sv` | SoC: processador, memória e E/S mapeada em memória (LEDs, displays, botões e chaves) |
| `dec7seg.sv` | Decodificador dos displays de sete segmentos |
| `tests/mem.sv` | Memória única para instruções e dados |
| `leds/leds.asm` | Programa dos LEDs |
| `leds/test.sv` | *Test bench* que imprime a tabela de botão e LEDs no terminal |
| `leds/run.sh` | Monta o programa e roda a simulação |

Endereços de E/S usados pelo programa:

| Endereço | Dispositivo | Acesso |
|---|---|---|
| `0x104` | `LEDR` | escrita (`sw`) |
| `0x110` | `KEY` | leitura (`lw`) |

## Dependências

Em Linux ou WSL (Ubuntu/Debian):

```sh
sudo apt update
sudo apt install iverilog gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf
```

## Como rodar a simulação

```sh
cd aoc/aocaoquadrado/leds
sh run.sh
```

O script monta o `leds.asm`, gera o `riscv.hex` (conteúdo da memória) e simula o `top.sv` com o Icarus Verilog.

## Saída esperada

Cada linha é uma escrita nos LEDs. A primeira coluna vale `1` quando o botão está apertado:

```
botão|Led9|Led8|Led7|Led6|Led5|Led4|Led3|Led2|Led1|Led0|
0|1|0|0|0|0|0|0|0|0|0|
0|0|1|0|0|0|0|0|0|0|0|
0|0|0|1|0|0|0|0|0|0|0|
0|0|0|0|1|0|0|0|0|0|0|
0|0|0|0|0|1|0|0|0|0|0|
0|0|0|0|0|0|1|0|0|0|0|
0|0|0|0|0|0|0|1|0|0|0|
0|0|0|0|0|0|0|0|1|0|0|
0|0|0|0|0|0|0|0|0|1|0|
0|0|0|0|0|0|0|0|0|0|1|
0|0|0|0|0|0|0|0|0|1|0|
0|0|0|0|0|0|0|0|1|0|0|
0|0|0|0|0|0|0|1|0|0|0|
0|0|0|0|0|0|1|0|0|0|0|
0|0|0|0|0|1|0|0|0|0|0|
0|0|0|0|1|0|0|0|0|0|0|
1|0|0|1|0|0|0|0|0|0|0|
0|1|0|0|0|0|0|0|0|0|0|
0|0|1|0|0|0|0|0|0|0|0|
...
```

Na linha com `1` o botão foi apertado, e na linha seguinte a sequência recomeça no `Led9`.

## Ajustes

- **Quando o botão é apertado na simulação:** altere o `wait (escritas == 16)` em `leds/test.sv`.
- **Qual botão reinicia:** altere a máscara do `andi t2, t2, 2` em `leds/leds.asm` (`2` = `KEY[1]`, `4` = `KEY[2]`, `8` = `KEY[3]`). O `KEY[0]` é o *reset* do processador.

## Na placa (DE0-CV)

O Quartus só usa os arquivos da pasta onde é executado. Depois de rodar a simulação, copie a memória e o programa para `aocaoquadrado` e rode o script de síntese e gravação:

```bat
cd aoc\aocaoquadrado
copy tests\mem.sv .
copy leds\riscv.hex .
make_wannabe.bat
```
