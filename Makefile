
TARGETS=tb

VSRC=\
	ttop.v \
	crc.v

NOT_YET=\
	crc8_wcdma.v

all: $(TARGETS)

tb: $(VSRC)
	iverilog -o $@ $^

run: $(TARGETS)
	vvp tb

plot:
	gtkwave -A --rcvar 'fontname_signals Monospace 13' --rcvar 'fontname_waves Monospace 12' tb.vcd

clean:
	rm -f $(TARGETS) *.vcd
