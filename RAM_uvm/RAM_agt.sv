package RAM_agtt;
    import uvm_pkg::*;
    import RAM_drive::*;
    import RAM_sequencer::*;
    import RAM_monitor::*;
    import RAM_configuration::*;
    import RAM_sequence_item::*;
    `include "uvm_macros.svh"

    class RAM_agt extends uvm_agent;
        `uvm_component_utils(RAM_agt)
        RAM_driver driver;
        RAM_monitor monitor;
        RAM_config cfg;
        RAM_sqr_class sqr;
        uvm_analysis_port #(RAM_seq_item) agt_ap;
        function new(string name="RAM_agt", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            monitor = RAM_monitor::type_id::create("mon",this);
        if(!uvm_config_db #(RAM_config) :: get(this,"","CFG",cfg))
        `uvm_fatal("build_phase","no");
        if(cfg.is_active==UVM_ACTIVE)
        begin
            driver = RAM_driver::type_id::create("driver",this);
            sqr = RAM_sqr_class::type_id::create("sqr",this);
        end
        agt_ap = new("agt_ap",this);
        endfunction
        
        function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        
        monitor.RAM_test_vif = cfg.RAM_test_vif;
        if(cfg.is_active==UVM_ACTIVE)
        begin
            driver.RAM_test_vif=cfg.RAM_test_vif;
            driver.seq_item_port.connect(sqr.seq_item_export);
        end
        monitor.mon_ap.connect(agt_ap);
    endfunction 
    endclass //className extends superClass
endpackage