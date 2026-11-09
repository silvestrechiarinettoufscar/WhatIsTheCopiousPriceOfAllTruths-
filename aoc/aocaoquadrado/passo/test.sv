// Test bench do SoC (top.sv) para o passo.asm: imprime no terminal o botao
// e os LEDs em intervalos fixos, para mostrar que o LED so anda quando o
// botao e apertado.
module test;
  reg        clk = 0;
  reg  [3:0] KEY = 4'b1110; // botoes ativos em 0; KEY[0] = reset (apertado)
  reg  [9:0] SW  = 0;
  wire [9:0] LEDR;
  wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
  integer    i;

  top dut(1'b0, KEY, SW, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  // na simulacao, troca o clock dividido (~12 Hz) por um clock rapido
  initial force dut.clk = clk;
  always #5 clk = ~clk;

  // roteiro do botao: um bit por intervalo, da esquerda para a direita
  // (1 = apertado). Dois 1 seguidos = botao segurado: so anda um passo.
  localparam N = 32;
  reg [0:N-1] roteiro = 32'b0010_1001_1100_1010_1010_1010_1010_1000;

  initial begin
    $display("botão|Led9|Led8|Led7|Led6|Led5|Led4|Led3|Led2|Led1|Led0|");
    #22 KEY[0] = 1;                   // solta o reset
    repeat (30) @(posedge clk);       // espera o programa acender o Led9
    for (i = 0; i < N; i = i + 1) begin
      KEY[1] = ~roteiro[i];
      @(posedge clk);                 // linha: botao agora, LEDs antes de reagir
      $display("%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|", ~KEY[1], LEDR[9], LEDR[8],
               LEDR[7], LEDR[6], LEDR[5], LEDR[4], LEDR[3], LEDR[2], LEDR[1], LEDR[0]);
      repeat (59) @(posedge clk);     // tempo para o programa reagir
    end
    $finish;
  end
endmodule
