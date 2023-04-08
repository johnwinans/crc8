/**
* @note Since this is a bit-serial implementation, there is no option at 
* this level to reflect the input bits.  (Input reflection normally 
* represents the natural order of the data arrival.)
***************************************************************************/
module crc 
#(
	// default settings for crc8_wcdma
	parameter	BITS	= 8,			///< How many bits wide is the CRC
	parameter	POLY	= 8'h9B,		///< The CRC polynomial
	parameter	INIT	= 8'h00,		///< the initial value of the CRC
	parameter	XOR_OUT = 8'h00,		///< XOR the result
	parameter	REF_OUT	= 1				///< reverse the bit order of the CRC
)
(
	input wire clk,						///< accept a new bit on rising edge
	input wire rst,						///< sync reset when true and clk rising edge
	input wire data,					///< message data bits
	input wire enable,					///< accept data when high & clk rising
	output wire [7:0] crc_out			///< the running value of calculated crc
);

	reg [BITS-1:0] crc_reg;

	wire xdi = crc_reg[BITS-1]^data;
	wire [BITS-1:0] poly_reg = {POLY[BITS-1:1],1'b0};	// turn off the low bit

	always @(posedge clk) begin
		if (rst) begin
			crc_reg <= INIT;
		end else if (enable) begin
			crc_reg <= {crc_reg[6:0], xdi} ^ (xdi ? poly_reg : 0);
		end
	end

	// reflect the output value & XOR the result... or not
	genvar j;
	generate for(j=0; j<BITS; j=j+1) 
		assign crc_out[j] = (REF_OUT ? crc_reg[BITS-1-j] : crc_reg[j]) ^ XOR_OUT[j]; 
	endgenerate

endmodule

