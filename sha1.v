`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2023 20:25:50
// Design Name: 
// Module Name: sha1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sha256 (
  input [31:0] input_data,
  input input_valid,
  input clk,
  input rst,
  output output_valid,
  output [255:0] hash_data
);
  // Internal signals and registers
  reg [31:0] state [0:7];
  reg [31:0] w [0:63];
  reg [7:0] count;
  reg [7:0] next_count;
  reg [31:0] temp1, temp2;
  reg [7:0] i;
  reg [7:0] j;

    localparam [31:0] K = {
    32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
    32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
    32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
    32'h72be5d74, 32'h80deb1fe, 32'heb86d391, 32'hbad90a6,
    32'hc1bdceee, 32'hf57c0faf, 32'h4787c62a, 32'ha8304613,
    32'hfd469501, 32'h698098d8, 32'h8b44f7af, 32'hfff5bb92,
    32'h895cd7be, 32'h6b901122, 32'hfd987193, 32'ha679438e,
    32'h49b40821, 32'hf61e2562, 32'hc040b340, 32'h265e5a51,
    32'he9b6c7aa, 32'hd62f105d, 32'h02441453, 32'hd8a1e681,
    32'he7d3fbc8, 32'h21e1cde6, 32'hc33707d6, 32'hf4d50d87,
    32'h455a14ed, 32'ha9e3e905, 32'hfcefa3f8, 32'h676f02d9,
    32'h8d2a4c8a, 32'hfffa3942, 32'h8771f681, 32'h6d9d6122,
    32'hfde5380c, 32'ha4beea44, 32'h4bdecfa9, 32'hf6bb4b60,
    32'hbebfbc70, 32'h289b7ec6, 32'heaa127fa, 32'hd4ef3085,
    32'h04881d05, 32'hd9d4d039, 32'he6db99e5, 32'h1fa27cf8,
    32'hc4ac5665, 32'hf4292244, 32'h432aff97, 32'hab9423a7,
    32'hfc93a039, 32'h655b5942  ,32'hbb7c8a9e,  32'h3e3eb98f,
    32'h8f0ccc92, 32'hffeff47d, 32'h85845dd1, 32'h6fa87e4f,
    32'hfe2ce6e0, 32'ha3014314, 32'h4e0811a1, 32'hf7537e82,
    32'hbd3af235, 32'h2ad7d2bb, 32'heb86d391, 32'h6d8dd37a,
    32'hbe0cd1f1, 32'h1fcbacd6, 32'h58e28650, 32'ha1,
    32'h6e9b2363, 32'hf1d839e4, 32'h4e0811a1, 32'hb8fd0c52
    };

  // Constants
  // Internal signals and registers
  wire [7:0] input_valid_delayed;
  reg [31:0] a, b, c, d, e, f, g, h;
  reg [31:0] w_temp;
  reg [31:0] s0, s1;
  reg [31:0] ch, maj;
  //reg [31:0] temp1, temp2;
  reg [31:0] a_temp, b_temp, c_temp, d_temp, e_temp, f_temp, g_temp, h_temp;

  // Output registers
  reg [255:0] hash_data_reg;
  reg output_valid_reg;

  // Register for counting the number of clock cycles
  reg [31:0] count_reg;

  // Combinational logic for delay
  assign input_valid_delayed = input_valid;

  // Register for storing the input data
  reg [31:0] input_data_reg;
  always @(posedge clk) begin
    if (rst) begin
      input_data_reg <= 0;
      count_reg <= 0;
      a <= 32'h6a09e667;
      b <= 32'hbb67ae85;
      c <= 32'h3c6ef372;
      d <= 32'ha54ff53a;
      e <= 32'h510e527f;
      f <= 32'h9b05688c;
      g <= 32'h1f83d9ab;
      h <= 32'h5be0cd19;
    end else begin
      input_data_reg <= input_data;
      count_reg <= count;
      a <= a_temp;
      b <= b_temp;
      c <= c_temp;
      d <= d_temp;
      e <= e_temp;
      f <= f_temp;
      g <= g_temp;
      h <= h_temp;
    end
  end

  // Combinational logic for processing the input data
  always @* begin
    w_temp = (i < 16) ? input_data_reg : w[i-7] + s0 + w[i-16] + s1;
    s0 = (w_temp >> 7) ^ (w_temp >> 18) ^ (w_temp >> 3);
    s1 = (w_temp >> 17) ^ (w_temp >> 19) ^ (w_temp >> 10);
    ch = (e & f) ^ (~e & g);
    maj = (a & b) ^ (a & c) ^ (b & c);
    temp1 = h + s1 + ch + K[i] + w_temp;
    temp2 = s0 + maj;
    h_temp = g;
    g_temp = f;
    f_temp = e;
    e_temp = d + temp1;
    d_temp = c;
    c_temp = b;
    b_temp = a;
    a_temp = temp1 + temp2;
  end

  // Sequential logic for processing the input data
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < 8; i = i + 1)
        state[i] <= 0;
    end else begin
      if (input_valid_delayed) begin
        state[0] <= a;
        state[1] <= b;
        state[2] <= c;
        state[3] <= d;
        state[4] <= e;
        state[5] <= f;
        state[6] <= g;
        state[7] <= h;
        count <= next_count;
      end else begin
        for (i = 0; i < 8; i = i + 1)
          state[i] <= state[i];
      end
    end
  end

  // Sequential logic for generating the hash output
  always @(posedge clk) begin
    if (rst) begin
      hash_data_reg <= 0;
      output_valid_reg <= 0;
    end else begin
      if (count_reg == 63) begin
        hash_data_reg <= {hash_data_reg[223:0], h, g, f, e, d, c, b, a};
        output_valid_reg <= 1;
      end else begin
        hash_data_reg <= hash_data_reg;
        output_valid_reg <= 0;
      end
    end
  end

  // Assigning outputs
  assign hash_data = hash_data_reg;
  assign output_valid = output_valid_reg;

  // SHA Engine
  always @(posedge clk) begin
    if (rst) begin
      next_count <= 0;
      i <= 0;
      j <= 0;
    end else begin
      next_count <= (input_valid_delayed) ? count + 1 : count;
      if (count_reg == 63) begin
        i <= 0;
        j <= j + 1;
      end else if (i == 63) begin
        i <= 0;
      end else begin
        i <= i + 1;
      end
    end
  end
endmodule


