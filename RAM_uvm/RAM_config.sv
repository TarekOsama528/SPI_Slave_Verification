package RAM_configuration;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_config extends uvm_object;
    `uvm_object_utils(RAM_config)
        virtual RAM_if RAM_test_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "RAM_config" );
        super.new(name);
        endfunction
        
endclass //className extends superClass
endpackage