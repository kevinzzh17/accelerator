onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib RAM_c3_c4_l4_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {RAM_c3_c4_l4.udo}

run -all

quit -force
