GTK_ARGS=-A --rcvar 'fontname_signals Monospace 13' --rcvar 'fontname_waves Monospace 12'

VSRC=\
	crc.v \
	crc_tb.v

all: crc

crc_tb.vvp: $(VSRC)
	iverilog -o $@ $^

crc_tb.vcd: crc_tb.vvp
	vvp $^

crc: crc_tb.vcd
	gtkwave $(GTK_ARGS) crc_tb.vcd

clean:
	rm -f *.vvp *.vcd
