# LED "vai e volta" (LEDR9 -> LEDR0 -> LEDR9 ...) que so anda quando o botao KEY[1] e apertado
# Um passo por aperto: segurar o botao nao faz o LED continuar andando.
# E/S mapeada em memoria: LEDR = 0x104 (escrita), KEY = 0x110 (leitura)
.text	# 0x00000000
.globl _start
_start:
	li   s0, 0x100        # base da E/S
	li   t0, 0x200        # so o LEDR9 aceso
	li   t1, 0            # direcao: 0 = direita (9->0), 1 = esquerda (0->9)
mostra:
	sw   t0, 4(s0)        # LEDR <- t0
espera_soltar:
	lw   t2, 0x10(s0)     # t2 <- KEY
	andi t2, t2, 2        # isola KEY[1]
	beqz t2, espera_soltar  # ainda apertado (ativo em 0): espera soltar
espera_apertar:
	lw   t2, 0x10(s0)     # t2 <- KEY
	andi t2, t2, 2        # isola KEY[1]
	bnez t2, espera_apertar # solto: o LED fica parado
	bnez t1, esquerda     # apertou: anda um passo
direita:
	srli t0, t0, 1
	li   t3, 1
	bne  t0, t3, mostra   # ainda nao chegou no LEDR0
	li   t1, 1            # chegou: inverte a direcao
	j    mostra
esquerda:
	slli t0, t0, 1
	li   t3, 0x200
	bne  t0, t3, mostra   # ainda nao chegou no LEDR9
	li   t1, 0            # chegou: inverte a direcao
	j    mostra
