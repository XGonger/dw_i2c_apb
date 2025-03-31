onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rkv_i2c_tb/apb_if/rstn
add wave -noupdate /rkv_i2c_tb/apb_if/paddr
add wave -noupdate /rkv_i2c_tb/apb_if/pwrite
add wave -noupdate /rkv_i2c_tb/apb_if/psel
add wave -noupdate /rkv_i2c_tb/apb_if/penable
add wave -noupdate /rkv_i2c_tb/apb_if/pwdata
add wave -noupdate /rkv_i2c_tb/apb_if/prdata
add wave -noupdate /rkv_i2c_tb/apb_if/pready
add wave -noupdate /rkv_i2c_tb/apb_if/pslverr
add wave -noupdate /rkv_i2c_tb/i2c_if/CLK
add wave -noupdate /rkv_i2c_tb/i2c_if/RST
add wave -noupdate /rkv_i2c_tb/i2c_if/SCL
add wave -noupdate /rkv_i2c_tb/i2c_if/SDA
add wave -noupdate /rkv_i2c_tb/dut/ic_rx_over_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_rx_under_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_tx_over_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_tx_abrt_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_rx_done_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_tx_empty_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_activity_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_stop_det_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_start_det_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_rd_req_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_rx_full_intr
add wave -noupdate /rkv_i2c_tb/dut/ic_gen_call_intr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5292088 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {82382725 ps} {95157620 ps}
