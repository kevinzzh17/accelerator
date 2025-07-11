onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib RAM_q2_l1_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {RAM_q2_l1.udo}

run -all

quit -force
