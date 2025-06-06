`ifndef RKV_I2C_MASTER_RESTART_CONTROL_VIRT_SEQ_SV
`define RKV_I2C_MASTER_RESTART_CONTROL_VIRT_SEQ_SV
class rkv_i2c_master_restart_control_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_restart_control_virt_seq)

  function new (string name = "rkv_i2c_master_restart_control_virt_seq");
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

    `uvm_do_on_with(apb_user_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;
                  })

    // write one byte, then read one byte
    `uvm_do_on_with(apb_write_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 1; 
                    packet[0] == 8'b1111_0000;
                   })

    fork 
      `uvm_do_on_with(apb_read_packet_seq, 
                        p_sequencer.apb_mst_sqr,
                      {packet.size() == 1; 
                      })     
    join_none          
    //-------------------------------------         
                  
    `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)     
        
    fork   
      `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == 1; 
                      packet[0] == 8'b1111_0000;
                      })
    join_none

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;
    
    rgm.IC_ENABLE.ENABLE.set(0);
    rgm.IC_ENABLE.update(status);

    `uvm_do_on_with(apb_user_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {IC_RESTART_EN == 0;
                    ENABLE == 1;
                  })

    // write one byte, then read one byte
    `uvm_do_on_with(apb_write_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 1; 
                    packet[0] == 8'b1111_0000;
                   })

    fork 
      `uvm_do_on_with(apb_read_packet_seq, 
                        p_sequencer.apb_mst_sqr,
                      {packet.size() == 1; 
                      })     
    join_none          
    //-------------------------------------

    `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)     
                         
    fork   
      `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == 1; 
                      packet[0] == 8'b1111_0000;
                      })
    join_none

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)


    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // RKV_I2C_MASTER_RESTART_CONTROL_VIRT_SEQ_SV
