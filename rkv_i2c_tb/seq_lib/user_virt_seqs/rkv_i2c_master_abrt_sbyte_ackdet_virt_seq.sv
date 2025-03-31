
`ifndef RKV_I2C_MASTER_ABRT_SBYTE_ACKDET_VIRT_SEQ_SV
`define RKV_I2C_MASTER_ABRT_SBYTE_ACKDET_VIRT_SEQ_SV

class rkv_i2c_master_abrt_sbyte_ackdet_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_abrt_sbyte_ackdet_virt_seq)

  function new (string name = "rkv_i2c_master_abrt_sbyte_ackdet_virt_seq");
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

    // Write some data and wait TX EMPTY interupt
    `uvm_do_on_with(apb_user_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    SPECIAL == 1;
                    GC_OR_START == 1;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;
                  })

    fork
      `uvm_do_on_with(i2c_slv_write_resp_seq,
                      p_sequencer.i2c_slv_sqr,
                      {nack_addr == 0;
                       NACK_START_BYTE == 0;
                      })
    join_none

    `uvm_do_on_with(apb_user_write_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 1; 
                    packet[0] == 8'b0101_0101;
                   })

    // while(1) begin
    //   rgm.IC_RAW_INTR_STAT.mirror(status);
    //   if(rgm.IC_RAW_INTR_STAT_START_DET.get())
    //     break;
    // end              
    
    `uvm_do_on_with(apb_intr_wait_seq,
                    p_sequencer.apb_mst_sqr,
                   {intr_id == IC_TX_ABRT_INTR_ID;
                   })

    rgm.IC_TX_ABRT_SOURCE.mirror(status);

    // check if interrupt output is same as interrupt status field
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_RX_UNDER_INTR_ID is not high")
       
    `uvm_do_on_with(apb_intr_clear_seq,
                    p_sequencer.apb_mst_sqr,
                    {intr_id == IC_TX_ABRT_INTR_ID;
                    })

    `uvm_do_on(apb_user_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // RKV_I2C_MASTER_ABRT_SBYTE_ACKDET_VIRT_SEQ_SV
