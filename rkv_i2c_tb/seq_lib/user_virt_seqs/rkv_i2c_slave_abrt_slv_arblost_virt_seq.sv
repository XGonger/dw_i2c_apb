`ifndef RKV_I2C_SLAVE_ABRT_SLV_ARBLOST_VIRT_SEQ_SV
`define RKV_I2C_SLAVE_ABRT_SLV_ARBLOST_VIRT_SEQ_SV
class rkv_i2c_slave_abrt_slv_arblost_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_slave_abrt_slv_arblost_virt_seq)

  function new (string name = "rkv_i2c_slave_abrt_slv_arblost_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    cfg.i2c_cfg.slave_cfg[0].is_active = 0;
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    cfg.i2c_cfg.master_cfg[0].is_active = 1;
    env.i2c_mst.reconfigure_via_task(cfg.i2c_cfg.master_cfg[0]);

    `uvm_do_on_with(apb_user_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {MASTER_MODE == 0; // master mode disabled
                     SPEED == 2;
                     IC_10BITADDR_SLAVE == 0; // Slave 7Bit addressing
                     IC_SLAVE_DISABLE == 0; // Slave mode is enabled
                     IC_SAR == 10'b11_0011_0011;
                     ENABLE == 1;
                  }) 

    // these data in the tx_fifo will be flushed
    `uvm_do_on_with(apb_write_packet_seq, 
            p_sequencer.apb_mst_sqr,
            {packet.size() == 2; 
              packet[0] == 8'h01;
              packet[1] == 8'h02;
            })  
    fork
      `uvm_do_on_with(i2c_mst_write_resp_seq, 
            p_sequencer.i2c_mst_sqr,
            { cmd == I2C_READ;
              addr == 10'b1100110011;
              addr_10bit == 0;    
              packet.size() == 4;             
            }) 
    join_none

    `uvm_do_on_with(apb_intr_wait_seq,
            p_sequencer.apb_mst_sqr,
            {intr_id == IC_TX_ABRT_INTR_ID;
            }) 
                
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is not high")

    tx_abrt_check();

    `uvm_do_on_with(apb_intr_clear_seq,
            p_sequencer.apb_mst_sqr,
            {intr_id == IC_TX_ABRT_INTR_ID;
            })

    `uvm_do_on_with(apb_intr_wait_seq,
                p_sequencer.apb_mst_sqr,
                {intr_id == IC_RD_REQ_INTR_ID;
                }) 
    
    if(vif.get_intr(IC_RD_REQ_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_RD_REQ_INTR_ID is not high") 

    `uvm_do_on_with(apb_write_packet_seq, 
        p_sequencer.apb_mst_sqr,
        {packet.size() == 2; 
          packet[0] == 8'hF0;
          packet[1] == 8'h0F;
        })

    `uvm_do_on_with(apb_write_packet_seq, 
        p_sequencer.apb_mst_sqr,
        {packet.size() == 2; 
          packet[0] == 8'h03;
          packet[1] == 8'h04;
        })

    i2c_if.sda_master = 0;

    // check if the dut lost the SDA
    `uvm_do_on_with(apb_intr_wait_seq,
      p_sequencer.apb_mst_sqr,
      {intr_id == IC_TX_ABRT_INTR_ID;
      })
                
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is not high")

    rgm.IC_TX_ABRT_SOURCE.mirror(status);
    if(!rgm.IC_TX_ABRT_SOURCE_ABRT_SLV_ARBLOST.get())
      `uvm_error("ABRT_SOURCE", "ABRT_SLV_ARBLOST should be high!")
    
    if(!rgm.IC_TX_ABRT_SOURCE_ARB_LOST.get())
      `uvm_error("ABRT_SOURCE", "ARB_LOST should be high!")

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

  task tx_abrt_check();
    while(1) begin
      @(posedge vif.i2c_clk)
      if(vif.intr[3] == 1) begin
        rgm.IC_TX_ABRT_SOURCE.mirror(status); 
        break;
      end
    end
  endtask

endclass
`endif // RKV_I2C_SLAVE_ABRT_SLV_ARBLOST_VIRT_SEQ_SV