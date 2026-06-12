package RAM_drive;
    import uvm_pkg::*;
    import RAM_configuration::*;
    import RAM_sequence_item::*;
    `include "uvm_macros.svh"

    class RAM_driver extends uvm_driver#(RAM_seq_item);
    `uvm_component_utils(RAM_driver)
    RAM_seq_item item;
    virtual RAM_if RAM_test_vif;
    RAM_config cfg;

        function new(string name="RAM_driver",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(RAM_config)::get(this,"","CFG",cfg)) begin
                `uvm_fatal("DRIVER","unable to get config object")
            end
    endfunction 

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            RAM_test_vif = cfg.RAM_test_vif;
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                item = RAM_seq_item::type_id::create("item");
                seq_item_port.get_next_item(item);
                // drive the interface
                @(negedge RAM_test_vif.clk);
                RAM_test_vif.din = item.din;
                RAM_test_vif.rx_valid = item.rx_valid;
                RAM_test_vif.rst_n = item.rst_n;

                seq_item_port.item_done();
            end
        endtask //run_phase

    endclass //className extends superClass
endpackage