onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib RAM_c1_c2_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {RAM_c1_c2.udo}

run -all

quit -force
