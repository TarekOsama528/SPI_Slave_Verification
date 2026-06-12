package RAM_scoreborad_pck;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_sequence_item::*;
    
class  RAM_scoreborad extends uvm_scoreboard;
`uvm_component_utils(RAM_scoreborad)

uvm_analysis_export #(RAM_seq_item) sb_export;
uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
RAM_seq_item item;
static int correct_count =0;
static int wrong_count =0;
// define refrences variables
    function new(string name = "RAM_scoreborad" , uvm_component parent = null);
        super.new(name,parent);
    endfunction
    
      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export=new("sb_export",this);
        sb_fifo=new("sb_fifo",this);
    endfunction 

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction 

     task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
        sb_fifo.get(item);
        // check results

        if (item.dout != item.dout_ref || item.tx_valid != item.tx_valid_ref) begin
            `uvm_error("run_phase",$sformatf("comparison failed: %s while ref=%d",item.dout,item.dout_ref));
            wrong_count++;
        end
        else correct_count++;
        end
    endtask //

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total correct transactions=%0d",correct_count),UVM_LOW);
        `uvm_info("report_phase",$sformatf("Total wrong transactions=%0d",wrong_count),UVM_LOW);
    endfunction
endclass 

    
endpackage