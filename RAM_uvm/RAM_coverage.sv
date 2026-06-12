package RAM_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_sequence_item::*;
class RAM_cover extends uvm_component;
`uvm_component_utils(RAM_cover)
uvm_analysis_export #(RAM_seq_item) cov_export;
uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
RAM_seq_item item;
parameter maxpos=255, zero=0 ;
covergroup g1 ;
        // coverage functions
        din_addr: coverpoint item.din[9:8] {
            bins addr_bins[] = {[0:3]};
            bins seq_bins = (0 => 1);
            bins seq2 = (1 => 0);
            bins seq3 = (2 => 3);
            bins seq4 = (0 => 1 => 2 => 3); // Transition bins for address sequence
        }
        din_data: coverpoint item.din[7:0] {
            bins data_bins[] = {[0:maxpos]};
        }
        rx_valid_cp: coverpoint item.rx_valid {
            bins valid_bins[] = {0, 1};
        }
        tx_valid_cp: coverpoint item.tx_valid {
            bins valid_bins[] = {0, 1};
        }
        din_cross: cross din_addr, rx_valid_cp {
            bins valid_addr_cross = binsof(rx_valid_cp) intersect {1} && binsof(din_addr);
            option.cross_auto_bin_max = 0; // No auto binning
        }
        data_cross: cross din_addr, tx_valid_cp {
            bins valid_data_cross = binsof(tx_valid_cp) intersect {1} && binsof(din_addr) intersect {3};
            option.cross_auto_bin_max = 0; // No auto binning
        }
        endgroup

   function new(string name = "RAM_cover" , uvm_component parent = null);
        super.new(name,parent);
        g1=new();
    endfunction
    
      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        cov_export=new("sb_export",this);
        cov_fifo=new("sb_fifo",this);
    endfunction 

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction 
    
     task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
        cov_fifo.get(item);
        g1.sample();
        end
    endtask
endclass 
    
endpackage