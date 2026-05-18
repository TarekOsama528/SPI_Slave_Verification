package scoreboard_pkg;
import uvm_pkg::*;
import sequence_item_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

uvm_analysis_export #(sequence_item) sb_export;
uvm_tlm_analysis_fifo #(sequence_item) sb_fifo;
sequence_item seq_item_sb;

int error_count=0;
int correct_count=0;

function new (string name="scoreboard", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export = new("sb_export",this);
sb_fifo = new("sb_fifo",this);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    sb_fifo.get(seq_item_sb);

    if (seq_item_sb.rx_data != seq_item_sb.rx_data_ref || 
    seq_item_sb.rx_valid != seq_item_sb.rx_valid_ref || seq_item_sb.MISO != seq_item_sb.MISO_ref) begin

        `uvm_error("run_phase",$sformatf("comparison failed: %s while ref=%d",seq_item_sb.convert2string(),seq_item_sb.rx_data_ref));
        error_count++;
    end else correct_count++;
end
endtask


function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("report_phase",$sformatf("Total correct transactions=%0d",correct_count),UVM_LOW);
`uvm_info("report_phase",$sformatf("Total error transactions=%0d",error_count),UVM_LOW);

endfunction
endclass
endpackage