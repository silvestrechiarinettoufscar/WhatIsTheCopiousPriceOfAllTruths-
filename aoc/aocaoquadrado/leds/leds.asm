# LED "vai e volta" (LEDR9 -> LEDR0 -> LEDR9 ...) com reinicio pelo botao KEY[1]
# E/S mapeada em memoria: LEDR = 0x104 (escrita), KEY = 0x110 (leitura)
.text	# 0x00000000
.globl _start
_start:
	li   s0, 0x100        # base da E/S
inicio:
	li   t0, 0x200        # so o LEDR9 aceso
	li   t1, 0            # direcao: 0 = direita (9->0), 1 = esquerda (0->9)
loop:
	sw   t0, 4(s0)        # LEDR <- t0
	lw   t2, 0x10(s0)     # t2 <- KEY
	andi t2, t2, 2        # isola KEY[1]
	beqz t2, inicio       # botao apertado (ativo em 0): volta ao inicio
	bnez t1, esquerda
direita:
	srli t0, t0, 1
	li   t3, 1
	bne  t0, t3, loop     # ainda nao chegou no LEDR0
	li   t1, 1            # chegou: inverte a direcao
	j    loop
esquerda:
	slli t0, t0, 1
	li   t3, 0x200
	bne  t0, t3, loop     # ainda nao chegou no LEDR9
	li   t1, 0            # chegou: inverte a direcao
	j    loop
