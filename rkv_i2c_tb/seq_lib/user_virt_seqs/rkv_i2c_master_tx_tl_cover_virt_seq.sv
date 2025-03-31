`ifndef RKV_I2C_TX_TL_COVER_VIRT_SEQ_SV
`define RKV_I2C_TX_TL_COVER_VIRT_SEQ_SV
class rkv_i2c_master_tx_tl_cover_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_tx_tl_cover_virt_seq)

  function new (string name = "rkv_i2c_master_tx_tl_cover_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [7:0] tx_fifo_thresh;
    bit [7:0] data[];
    int n = 0;
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    `uvm_do_on_with(apb_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                  })

    for(n = 0; n < 32; n++) begin
      
      std::randomize(tx_fifo_thresh) with {tx_fifo_thresh inside {[0:8]};};
      rgm.IC_ENABLE_ENABLE.set(1);
      rgm.IC_ENABLE.update(status);

      rgm.IC_TX_TL_TX_TL.set(tx_fifo_thresh);
      rgm.IC_TX_TL.update(status);

      std::randomize(data) with {data.size() == tx_fifo_thresh; foreach(data[i]) data[i] == (i+1);};

      if((tx_fifo_thresh > 0) && (tx_fifo_thresh < 8)) begin // tx_fifo_thresh = 0, don't write, directly check,
        `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                    {packet.size() == tx_fifo_thresh;
                      foreach(packet[i]) packet[i] == (i+1);
                    })
      end
      
      if(tx_fifo_thresh < 8) begin
        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(!rgm.IC_RAW_INTR_STAT_TX_EMPTY.get())
          `uvm_error("TXTHRESH", $sformatf("the tx_fifo_thresh is %0d, tx fifo should be empty!", tx_fifo_thresh))

        `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                        p_sequencer.apb_mst_sqr,
                      {packet.size() == 1; 
                        packet[0] == 8'hF0;
                      })

        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(rgm.IC_RAW_INTR_STAT_TX_EMPTY.get())
          `uvm_error("TXTHRESH", $sformatf("the tx_fifo_thresh is %0d, tx fifo empty should not be empty!", tx_fifo_thresh))
      end
      else begin //tx_fifo_thresh = 8, only write 7 bytes,
        `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                    {packet.size() == 7;
                      foreach(packet[i]) packet[i] == (i+1);
                    })
        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(!rgm.IC_RAW_INTR_STAT_TX_EMPTY.get())
          `uvm_error("TXTHRESH", $sformatf("the tx_fifo_thresh is %0d, tx fifo should be empty!", tx_fifo_thresh))
      end
      
      `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)

      `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

      rgm.IC_ENABLE_ENABLE.set(0);
      rgm.IC_ENABLE.update(status);
    end
       
    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // RKV_I2C_TX_TL_COVER_VIRT_SEQ_SV
