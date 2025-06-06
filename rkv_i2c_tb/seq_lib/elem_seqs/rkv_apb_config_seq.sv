
`ifndef RKV_APB_CONFIG_SEQ_SV
`define RKV_APB_CONFIG_SEQ_SV

class rkv_apb_config_seq extends rkv_apb_base_sequence;

  `uvm_object_utils(rkv_apb_config_seq)

  constraint def_cstr {
    soft SPEED == -1;
    soft IC_10BITADDR_MASTER == -1;
    soft IC_TAR == -1;
    soft IC_FS_SCL_HCNT == -1;
    soft IC_FS_SCL_LCNT == -1;
    soft ENABLE == -1;
    soft IC_SAR == -1;
    soft RX_TL == -1;
  }

  function new (string name = "rkv_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    if(SPEED >= 0) rgm.IC_CON.SPEED.set(SPEED);
    //rgm.IC_CON.MASTER_MODE.set('h1);
    if(IC_10BITADDR_MASTER >= 0) rgm.IC_CON.IC_10BITADDR_MASTER.set(IC_10BITADDR_MASTER);
    rgm.IC_CON.update(status);

    if(IC_TAR >= 0) rgm.IC_TAR.IC_TAR.set(IC_TAR);
    rgm.IC_TAR.update(status);

    if(IC_SAR >= 0) rgm.IC_SAR.IC_SAR.set(IC_SAR);
    rgm.IC_SAR.update(status);

    // SCL_HCNT + SCL_LCNT = I2C baud clock T 
    // 2us + 2us -> 1000/4 = 250Kb/s
    if(IC_FS_SCL_HCNT >= 0) rgm.IC_FS_SCL_HCNT.write(status, 200); // 2us 
    if(IC_FS_SCL_LCNT >= 0) rgm.IC_FS_SCL_LCNT.write(status, 200); // 2us

    // rx fifo threshold control
    if(RX_TL >= 0) rgm.IC_RX_TL_RX_TL.set(RX_TL);
    rgm.IC_RX_TL.update(status);

    if(ENABLE >= 0) rgm.IC_ENABLE.ENABLE.set('h1);
    rgm.IC_ENABLE.update(status);

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // RKV_APB_CONFIG_SEQ_SV
