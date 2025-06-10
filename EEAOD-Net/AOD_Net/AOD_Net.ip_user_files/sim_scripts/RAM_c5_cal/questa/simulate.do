onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib RAM_c5_cal_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {RAM_c5_cal.udo}

run -all

quit -force
