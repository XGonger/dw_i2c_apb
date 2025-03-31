`ifndef RKV_I2C_MASTER_DIRECTED_READ_PACKET_VIRT_SEQ_SV
`define RKV_I2C_MASTER_DIRECTED_READ_PACKET_VIRT_SEQ_SV
class rkv_i2c_master_directed_read_packet_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_directed_read_packet_virt_seq)

  function new (string name = "rkv_i2c_master_directed_read_packet_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    cfg.i2c_cfg.slave_cfg[0].is_active = 1;
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    cfg.i2c_cfg.master_cfg[0].is_active = 0;
    env.i2c_mst.reconfigure_via_task(cfg.i2c_cfg.master_cfg[0]);

    `uvm_do_on_with(apb_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    RX_TL == 8;
                    ENABLE == 1;
                  })

    fork
      `uvm_do_on_with(apb_read_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                     {packet.size() == 2; 
                     })
                    
      `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                     {packet.size() == 2; 
                      packet[0] == 8'b1111_0000;
                      packet[1] == 8'b0101_0101;
                     })
    join

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask


endclass
`endif // RKV_I2C_MASTER_DIRECTED_READ_PACKET_VIRT_SEQ_SV
