`ifndef RKV_I2C_TX_OVER_INTR_VIRT_SEQ_SV
`define RKV_I2C_TX_OVER_INTR_VIRT_SEQ_SV
class rkv_i2c_master_tx_over_intr_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_master_tx_over_intr_virt_seq)

  function new (string name = "rkv_i2c_master_tx_over_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
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
                    ENABLE == 1;
                  })

    `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 8; 
                    packet[0] == 8'b1111_0000;
                    packet[1] == 8'b0101_0101;
                    packet[2] == 8'b0101_1001;
                    packet[3] == 8'b0101_1001;
                    packet[4] == 8'b0101_1001;
                    packet[5] == 8'b0101_1001;
                    packet[6] == 8'b0101_1001;
                    packet[7] == 8'b0101_1001;
                   })

    rgm.IC_STATUS.mirror(status); // tx_fifo should be full

    fork
      `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    join_none

    while(1) begin
      rgm.IC_RAW_INTR_STAT.mirror(status);
      if(rgm.IC_RAW_INTR_STAT_START_DET.get())
        break;
    end

    fork
      `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 2; 
                    packet[0] == 8'b1111_0000;
                    packet[1] == 8'b0000_1111;
                   })

      begin
        `uvm_do_on_with(apb_intr_wait_seq,
                    p_sequencer.apb_mst_sqr,
                   {intr_id == IC_TX_OVER_INTR_ID;
                   })
                   
        if(vif.get_intr(IC_TX_OVER_INTR_ID) !== 1'b1) begin
          `uvm_error("INTRERR", "interrupt output IC_RX_OVER_INTR_ID is not high")
        end

        `uvm_do_on_with(apb_intr_clear_seq,
                        p_sequencer.apb_mst_sqr,
                        {intr_id == IC_TX_OVER_INTR_ID;
                        })
      end
      begin
        `uvm_do_on_with(apb_intr_wait_seq,
                    p_sequencer.apb_mst_sqr,
                   {intr_id == IC_TX_ABRT_INTR_ID;
                   })

        if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1) begin
            `uvm_error("INTRERR", "interrupt output IC_TX_OVER_INTR_ID is not high")
          end

        tx_abrt_check();
      end

    join_any

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
`endif // RKV_I2C_TX_OVER_INTR_VIRT_SEQ_SV
