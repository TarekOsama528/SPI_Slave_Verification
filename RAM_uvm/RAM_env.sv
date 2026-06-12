package RAM_env_pac;
import uvm_pkg::*;
import RAM_agtt::*;
import RAM_coverage_pkg::*;
import RAM_scoreborad_pck::*;
`include "uvm_macros.svh"

class RAM_env extends uvm_env;
    `uvm_component_utils(RAM_env)
    RAM_agt agt;
    RAM_scoreborad sb;
    RAM_cover cov;
    function new(string name = "RAM_env" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agt = RAM_agt::type_id::create("agt",this);
        sb = RAM_scoreborad::type_id::create("sb",this);
        cov = RAM_cover::type_id::create("cov",this);
    endfunction 
    
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction 
endclass 
    
endpackage