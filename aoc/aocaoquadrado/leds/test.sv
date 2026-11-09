// Test bench do SoC (top.sv): imprime no terminal o botao e os LEDs
// a cada escrita do programa em LEDR.
module test;
  reg        clk = 0;
  reg  [3:0] KEY = 4'b1110; // botoes ativos em 0; KEY[0] = reset (apertado)
  reg  [9:0] SW  = 0;
  wire [9:0] LEDR;
  wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
  integer    i, escritas = 0;

  top dut(1'b0, KEY, SW, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  // na simulacao, troca o clock dividido (~12 Hz) por um clock rapido
  initial force dut.clk = clk;
  always #5 clk = ~clk;

  // uma linha da tabela a cada escrita em LEDR (0x104)
  wire escreve_led = dut.memwrite & dut.isIO & dut.addr[dut.IO_LEDS_bit];
  wire botao = ~KEY[1]; // 1 = apertado
  always @(posedge clk)
    if (escreve_led) begin
      escritas <= escritas + 1;
      $strobe("%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|%b|", botao, LEDR[9], LEDR[8],
              LEDR[7], LEDR[6], LEDR[5], LEDR[4], LEDR[3], LEDR[2], LEDR[1], LEDR[0]);
    end

  // aperta KEY[1] um pouco antes da proxima escrita e solta logo depois dela
  task aperta_botao;
    begin
      repeat (20) @(posedge clk); KEY[1] = 0;
      repeat (35) @(posedge clk); KEY[1] = 1;
    end
  endtask

  initial begin
    $dumpfile("dump.vcd"); $dumpvars(0, test);
    $display("botão|Led9|Led8|Led7|Led6|Led5|Led4|Led3|Led2|Led1|Led0|");
    #22 KEY[0] = 1;            // solta o reset
    wait (escritas == 16);     // desce ate o Led0 e comeca a voltar...
    aperta_botao;              // ...aperta o botao: tem que voltar ao Led9
    wait (escritas == 30);
    #1 $finish;
  end
endmodule
