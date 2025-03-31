`ifndef RKV_I2C_RX_TL_COVER_VIRT_SEQ_SV
`define RKV_I2C_RX_TL_COVER_VIRT_SEQ_SV
class rkv_i2c_master_rx_tl_cover_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_rx_tl_cover_virt_seq)

  function new (string name = "rkv_i2c_master_rx_tl_cover_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [7:0] rx_fifo_thresh;
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

    for(n = 8; n >= 0; n--) begin
      
      // std::randomize(rx_fifo_thresh) with {rx_fifo_thresh inside {[0:8]};};
      rx_fifo_thresh = n;
      rgm.IC_ENABLE_ENABLE.set(1);
      rgm.IC_ENABLE.update(status);

      rgm.IC_RX_TL_RX_TL.set(rx_fifo_thresh);
      rgm.IC_RX_TL.update(status);

      std::randomize(data) with {data.size() == rx_fifo_thresh; foreach(data[i]) data[i] == (i+1);};

      if((rx_fifo_thresh > 0) && (rx_fifo_thresh < 8)) begin
        // receive rw_fifo_thresh bytes and then check RX_FULL
        fork
          `uvm_do_on_with(apb_noread_packet_seq,p_sequencer.apb_mst_sqr,{packet.size() == rx_fifo_thresh;})

          `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == rx_fifo_thresh;
                       foreach(packet[i]) packet[i] == (i+1);
                       })

        join
        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(rgm.IC_RAW_INTR_STAT_RX_FULL.get())
          `uvm_error("RXTHRESH", $sformatf("the rx_fifo_thresh is %0d, rx fifo should not be full!", rx_fifo_thresh))
        
        // receive 1 more byte and then check RX_FIFO, 
        fork
          `uvm_do_on_with(apb_noread_packet_seq,p_sequencer.apb_mst_sqr,{packet.size() == 1;})

          `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == 1;
                       packet[0] == 8'hF0;
                       })

        join

        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(!rgm.IC_RAW_INTR_STAT_RX_FULL.get())
          `uvm_error("RXTHRESH", $sformatf("the rx_fifo_thresh is %0d, rx fifo should be full!", rx_fifo_thresh))
      end
      else if(rx_fifo_thresh == 0) begin
        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(rgm.IC_RAW_INTR_STAT_RX_FULL.get())
          `uvm_error("RXTHRESH", $sformatf("the rx_fifo_thresh is %0d, rx fifo should not be full!", rx_fifo_thresh))
        
        // receive 1 byte and then check RX_FIFO, 
        fork
          `uvm_do_on_with(apb_noread_packet_seq,p_sequencer.apb_mst_sqr,{packet.size() == 1;})

          `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == 1;
                       packet[0] == 8'hF0;
                       })

        join

        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(!rgm.IC_RAW_INTR_STAT_RX_FULL.get())
          `uvm_error("RXTHRESH", $sformatf("the rx_fifo_thresh is %0d, rx fifo should be full!", rx_fifo_thresh))     
      end
      else begin // rx_fifo_thresh == 8
        // receive rw_fifo_thresh bytes and then check RX_FULL
        fork
          `uvm_do_on_with(apb_noread_packet_seq,p_sequencer.apb_mst_sqr,{packet.size() == rx_fifo_thresh;})

          `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                      {packet.size() == rx_fifo_thresh;
                       foreach(packet[i]) packet[i] == (i+1);
                       })

        join
        rgm.IC_RAW_INTR_STAT.mirror(status);
        if(!rgm.IC_RAW_INTR_STAT_RX_FULL.get())
          `uvm_error("RXTHRESH", $sformatf("the rx_fifo_thresh is %0d, rx fifo should be full!", rx_fifo_thresh))

      end
      repeat (rx_fifo_thresh == 8 ? 8 : rx_fifo_thresh+1) rgm.IC_DATA_CMD.mirror(status); // get data from data register

      `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

      rgm.IC_ENABLE_ENABLE.set(0);
      rgm.IC_ENABLE.update(status);
    end
       
    #10us;

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // RKV_I2C_RX_TL_COVER_VIRT_SEQ_SV
