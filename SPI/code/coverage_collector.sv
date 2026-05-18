package cover_collect_pkg;
import uvm_pkg::*;
import sequence_item_pkg::*;
`include "uvm_macros.svh"

class cover_collect extends uvm_component;
`uvm_component_utils(cover_collect)
uvm_analysis_export #(sequence_item) cov_export;
uvm_tlm_analysis_fifo #(sequence_item) cov_fifo;
sequence_item cov_seq;

covergroup cov_grp;
rx_data: coverpoint cov_seq.rx_data[9:8]{
    bins values[] = {[0:3]};
    // Cover all possible transitions (more comprehensive)
    bins trans[] = (0,1,2,3 => 0,1,2,3);
    ignore_bins i_tran = (0 => 2), (0 => 3), (2 => 3), (3 => 1);

}

ss_n: coverpoint cov_seq.SS_n {
    bins normal_transaction1 = (1 => 0 [*13] => 1);
    bins normal_transaction2 = (1 => 0 [*23] => 1);
}

//000 (Write Address)
//001 (Write Data)
//110 (Read Address)
//111 (Read Data)

mosi_command_transitions: coverpoint cov_seq.MOSI {
        bins write_addr = (0 => 0 => 0);
        bins write_data = (1 => 0 => 0);
        bins read_addr  = (0 => 1 => 1);
        bins read_data  = (1 => 1 => 1);
    }

cp1: coverpoint cov_seq.MOSI{
    bins low = {0};
    bins high = {1};
    option.weight=0;
}

cp2: coverpoint cov_seq.SS_n{
    bins low = {0};
    bins high = {1};
    option.weight=0;
}

cross_: cross cp1, cp2  {
    bins correct_combs = binsof(cp1) && binsof(cp2.low);
    option.cross_auto_bin_max=0;
}
endgroup

function new(string name = "cover_collect",uvm_component parent = null);
super.new(name,parent);
cov_grp = new();
endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
cov_export = new("cov_export",this);
cov_fifo = new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
super.run_phase(phase);
forever begin
    
    cov_fifo.get(cov_seq);
    cov_grp.sample();
end
endtask
endclass
endpackage