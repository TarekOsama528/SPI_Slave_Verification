package RAM_monitor;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_sequence_item::*;

    class RAM_monitor extends uvm_monitor;
        `uvm_component_utils(RAM_monitor)
        RAM_seq_item item;
        virtual RAM_if RAM_test_vif;
        uvm_analysis_port #(RAM_seq_item) mon_ap;

        function new(string name = "RAM_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap=new("mon_ap",this);
        endfunction 

        task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = RAM_seq_item::type_id::create("item");
            @(negedge RAM_test_vif.clk);
            //assign item variables 
            item.din = RAM_test_vif.din;
            item.rst_n = RAM_test_vif.rst_n;
            item.rx_valid = RAM_test_vif.rx_valid;

            item.tx_valid = RAM_test_vif.tx_valid;
            item.dout = RAM_test_vif.dout;
            item.tx_valid_ref = RAM_test_vif.tx_valid_ref;
            item.dout_ref = RAM_test_vif.dout_ref;

            mon_ap.write(item);
            `uvm_info("run_phase",item.convert2string(),UVM_HIGH);
        end
    endtask //
    endclass //className extends superClass
endpackage