`ifndef RKV_I2C_MASTER_RX_UNDER_INTR_VIRT_SEQ_SV
`define RKV_I2C_MASTER_RX_UNDER_INTR_VIRT_SEQ_SV

class rkv_i2c_master_rx_under_intr_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_rx_under_intr_virt_seq)

  function new (string name = "rkv_i2c_master_rx_under_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    // Write some data and wait TX EMPTY interupt
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

    // read when rx_fifo is empty
    rgm.IC_DATA_CMD.mirror(status);

    `uvm_do_on_with(apb_noread_packet_seq,p_sequencer.apb_mst_sqr,{packet.size() == 1;})

    // `uvm_do_on_with(apb_intr_wait_seq,
    //             p_sequencer.apb_mst_sqr,
    //             {intr_id == IC_RX_UNDER_INTR_ID;
    //             })
                   
    // if(vif.get_intr(IC_RX_UNDER_INTR_ID) !== 1'b1)
    //   `uvm_error("INTRERR", "interrupt output IC_RX_OVER_INTR_ID is not high")   

    // // check the RX_UNDER clear begin
    // `uvm_do_on_with(apb_intr_clear_seq,
    //     p_sequencer.apb_mst_sqr,
    //     {intr_id == IC_RX_UNDER_INTR_ID;
    //     })

    // rgm.IC_RAW_INTR_STAT.mirror(status);
    // if(rgm.IC_RAW_INTR_STAT_RX_UNDER)
    //   `uvm_error("INTR_CLEAR", "RX_OVER clear failed!")
    // // check the RX_OVER clear end

    `uvm_do_on_with(i2c_slv_read_resp_seq, 
                p_sequencer.i2c_slv_sqr,
                {packet.size() == 1;
                  packet[0] == 8'b1111_0000;
                  })

    rgm.IC_DATA_CMD.mirror(status);    

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)          

    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask
endclass
`endif // RKV_I2C_RX_UNDER_INTR_VIRT_SEQ_SV



