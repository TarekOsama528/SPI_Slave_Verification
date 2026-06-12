package RAM_test_pkg;
import RAM_env_pac::*;
import uvm_pkg::*;
// import sequences
import read_write_sequence::*;
import read_only_sequence::*;
import write_only_sequence::*;
import reset_sequence::*;

import RAM_configuration::*;
`include "uvm_macros.svh"
class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)
    RAM_config conf_RAM;
    RAM_env env_RAM;
    // define sequences
    reset_seq reset_seqq;
    read_write_seq main_seq3;
    write_only_seq main_seq1;
    read_only_seq main_seq2;

    function new(string name = "RAM_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env_RAM = RAM_env::type_id::create("env",this);
        conf_RAM= RAM_config::type_id::create("config",this);
        reset_seqq = reset_seq::type_id::create("reset_seq",this);
        main_seq1 = write_only_seq::type_id::create("main_seq1",this);
        main_seq2 = read_only_seq::type_id::create("main_seq2",this);
        main_seq3 = read_write_seq::type_id::create("main_seq3",this);
        if(!uvm_config_db#(virtual RAM_if)::get(this,"","RAM_test_vif",conf_RAM.RAM_test_vif))
        `uvm_fatal("build_phase","Virtual interface not set for RAM_test_vif");
        conf_RAM.is_active = UVM_ACTIVE;// to make it passive we can use UVM_PASSIVE
        uvm_config_db#(RAM_config)::set(null,"*","CFG",conf_RAM);
    endfunction 

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        // run sequences
        `uvm_info("TEST", "Starting RAM test", UVM_LOW)
        reset_seqq.start(env_RAM.agt.sqr);
        `uvm_info("TEST", "Reset sequence completed", UVM_LOW)

        `uvm_info("TEST", "Starting write only sequence", UVM_LOW)
        main_seq1.start(env_RAM.agt.sqr);
        `uvm_info("TEST", "Main sequence completed", UVM_LOW)

        `uvm_info("TEST", "Starting read only sequence", UVM_LOW)
        main_seq2.start(env_RAM.agt.sqr);
        `uvm_info("TEST", "Main sequence completed", UVM_LOW)

        `uvm_info("TEST", "Starting read write sequence", UVM_LOW)
        main_seq3.start(env_RAM.agt.sqr);
        `uvm_info("TEST", "Main sequence completed", UVM_LOW)
        
        `uvm_info("run_phase", $sformatf("correct_count=%0d , wrong_count = %0d",env_RAM.sb.correct_count,env_RAM.sb.wrong_count),UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
    

endclass 

endpackage