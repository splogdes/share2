module next_round_key #(
    parameter i = 8
)(
    input logic [7:0][3:0][7:0] key,
    input logic clk,
    output logic [7:0][3:0][7:0] next_key
);

    localparam [10:0][7:0] rcon = {
        8'h36, 8'h1B, 8'h80, 8'h40, 8'h20, 8'h10, 8'h08, 8'h04, 8'h02, 8'h01, 8'h00
    };

    logic [3:0][7:0] rot_word_temp;
    logic [3:0][7:0] sub_word_temp;
    logic [3:0][7:0] temp_0;

    rot_word rot_word_inst (
        .word(key[7]),
        .rot_word(rot_word_temp)
    );
    sub_word sub_word_inst_0 (
        .word(rot_word_temp),
        .sub_word(sub_word_temp)
    );

    assign temp_0 = {sub_word_temp[3] ^ rcon[i >> $clog2(8)], sub_word_temp[2], sub_word_temp[1], sub_word_temp[0]};

    logic [3:0][3:0][7:0] next_half_key_temp;

    always_comb begin
        next_half_key_temp[0] = key[0] ^ temp_0;
        next_half_key_temp[1] = key[1] ^ next_half_key_temp[0];
        next_half_key_temp[2] = key[2] ^ next_half_key_temp[1];
        next_half_key_temp[3] = key[3] ^ next_half_key_temp[2];
    end

    logic [3:0][3:0][7:0] half_key_store;
    logic [3:0][3:0][7:0] next_half_key_store;

    always_ff @( posedge clk ) begin
        half_key_store <= key[7:4];
        next_half_key_store <= next_half_key_temp;
    end

    logic [3:0][7:0] temp_4;

    sub_word sub_word_inst_4 (
        .word(next_half_key_store[3]),
        .sub_word(temp_4)
    );

    always_comb begin
        next_key[3:0] = next_half_key_store;
        next_key[4] = half_key_store[0] ^ temp_4;
        next_key[5] = half_key_store[1] ^ next_key[4];
        next_key[6] = half_key_store[2] ^ next_key[5];
        next_key[7] = half_key_store[3] ^ next_key[6];
    end


endmodule

