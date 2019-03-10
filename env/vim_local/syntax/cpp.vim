" Vim syntax file for SystemC
"
" Maintainer:	Karthick Gururaj <stonnedsnake@yahoo.com>
" Last change:	Nov 30 2003
" Version:     1.0

let file_syntax = SysC_or_CPP()
"if(file_syntax == "cpp")
"   finish
"endif

" Else.. add SystemC highlighting

" Macros in SystemC
syntax keyword sysC_Macro SC_PROTOCOL SC_CTHREAD SC_THREAD 
syntax keyword sysC_Macro SC_SLAVE SC_CTOR SC_METHOD SC_MODULE SC_HAS_PROCESS
syntax keyword sysC_Macro SC_FS SC_PS SC_NS SC_US SC_MS SC_SEC

" SystemC Functions
syntax match sysC_Func "\zs\<get_value\ze[ |	]*("
syntax match sysC_Func "\zs\<post\ze[ |	]*("
syntax match sysC_Func "\zs\<trywait\ze[ |	]*(" 
syntax match sysC_Func "\zs\<kind\ze[ |	]*("
syntax match sysC_Func "\zs\<unlock\ze[ |	]*("
syntax match sysC_Func "\zs\<trylock\ze[ |	]*("
syntax match sysC_Func "\zs\<lock\ze[ |	]*("
syntax match sysC_Func "\zs\<num_available\ze[ |	]*("
syntax match sysC_Func "\zs\<nb_read\ze[ |	]*("
syntax match sysC_Func "\zs\<num_free\ze[ |	]*(" 
syntax match sysC_Func "\zs\<nb_write\ze[ |	]*("
syntax match sysC_Func "\zs\<negedge_event\ze[ |	]*("
syntax match sysC_Func "\zs\<posedge_event\ze[ |	]*("
syntax match sysC_Func "\zs\<default_event\ze[ |	]*("
syntax match sysC_Func "\zs\<value_change_event\ze[ |	]*("
syntax match sysC_Func "\zs\<watching\ze[ |	]*("
syntax match sysC_Func "\zs\<duty_cycle\ze[ |	]*(" 
" syntax match sysC_Func "\zs\<sensitive_neg\ze[ |	]*("
" syntax match sysC_Func "\zs\<sensitive_pos\ze[ |	]*("
" syntax match sysC_Func "\zs\<sensitive\ze[ |	]*(" 
syntax match sysC_Func "\zs\<name\ze[ |	]*(" 
syntax match sysC_Func "\zs\<period\ze[ |	]*("
syntax match sysC_Func "\zs\<negedge\ze[ |	]*("
syntax match sysC_Func "\zs\<posedge\ze[ |	]*("
syntax match sysC_Func "\zs\<neg\ze[ |	]*(" 
syntax match sysC_Func "\zs\<pos\ze[ |	]*(" 
syntax match sysC_Func "\zs\<event\ze[ |	]*("
syntax match sysC_Func "\zs\<initialize\ze[ |	]*("
syntax match sysC_Func "\zs\<dont_initialize\ze[ |	]*(" 
syntax match sysC_Func "\zs\<next_trigger\ze[ |	]*("
syntax match sysC_Func "\zs\<notify\ze[ |	]*("
syntax match sysC_Func "\zs\<wait\ze[ |	]*(" 
syntax match sysC_Func "\zs\<read\ze[ |	]*("
syntax match sysC_Func "\zs\<end_of_elaboration\ze[ |	]*("
syntax match sysC_Func "\zs\<write\ze[ |	]*("
syntax match sysC_Func "\zs\<sc_time_stamp\ze[ |	]*(" 
syntax match sysC_Func "\zs\<sc_main\ze[ |	]*(" 
syntax match sysC_Func "\zs\<sc_start\ze[ |	]*("
syntax match sysC_Func "\zs\<sc_trace\ze[ |	]*("
syntax match sysC_Func "\zs\<sc_trace_file\ze[ |	]*(" 
syntax match sysC_Func "\zs\<sc_stop\ze[ |	]*("
syntax match sysC_Func "\zs\<sc_set_time_resolution\ze[ |	]*(" 
syntax match sysC_Func "\zs\<sc_get_default_time_unit\ze[ |	]*("
syntax match sysC_Func "\zs\<sc_get_time_resolution\ze[ |	]*(" 
syntax match sysC_Func "\zs\<sc_set_default_time_unit\ze[ |	]*("

" These can be used as streams too
syntax keyword sysC_Func sensitive
syntax keyword sysC_Func sensitive_neg
syntax keyword sysC_Func sensitive_pos

" SystemC classes
syntax keyword sysC_Type sc_semaphore sc_mutex sc_fifo sc_buffer sc_prim_channel sc_port sc_interface
syntax keyword sysC_Type sc_link_mp sc_event sc_buffer sc_semaphore_if sc_semaphore sc_mutex_if sc_mutex
syntax keyword sysC_Type sc_fifo_in sc_fifo_out sc_fifo_out_if sc_fifo_in_if sc_fifo sc_signal_rv sc_signal
syntax keyword sysC_Type sc_inout_rv sc_out_rv sc_in_rv sc_inout sc_out sc_in sc_interface
syntax keyword sysC_Type sc_channel sc_port sc_out_clk sc_in_clk sc_inoutslave sc_outslave sc_inslave
syntax keyword sysC_Type sc_slave sc_inoutmaster sc_outmaster sc_inmaster sc_master sc_module_name sc_clock
syntax keyword sysC_Type sc_time sc_ufix sc_fix sc_ufixed sc_fixed sc_lv sc_bv
syntax keyword sysC_Type sc_biguint sc_bigint sc_uint sc_int sc_logic sc_bit sc_module
"user I/F
syntax keyword sysC_Type squa_stream_in squa_stream_out squa_stream_base_in squa_stream_base_out squa_stream
syntax keyword sysC_Type squa_event_in squa_event_out squa_event sq_txt_dump_ctrl
syntax keyword sysC_Type squa_stream_tb_in squa_stream_tb_out
syntax keyword sysC_Type squa_stream_delay squa_stream_fifo
syntax keyword sysC_Type cynw_p2p CYN_PROTOCOL CYN_STABLE_INPUT CYN_INITIATE CYN_LATENCY CYN_DPOPT_INLINE
"user Func
syntax keyword sysC_Func ioConfig SSOPT reset range fetch set_size start_tx start_rx end_tx end_rx next_dump_file 
"user Marco
syntax keyword sysC_Macro SQUA_THREAD_async SQUA_THREAD_sync_async 
syntax keyword sysC_Macro SQUA_FETCH_STREAM stream_fifo
syntax match sysC_Macro "SQUA_STREAM_SYNC_FETCH_BEGIN*" 
syntax match sysC_Macro "SQUA_STREAM_SYNC_FETCH_END*" 
syntax match sysC_Macro "SQUA_STREAM_SYNC_OUT_BEGIN*" 
syntax match sysC_Macro "SQUA_STREAM_SYNC_OUT_END*" 

" And the highlighting
hi! sysC_Func ctermfg=NONE guifg=darkgray
hi! link sysC_Macro Constant
hi! link sysC_Type Type

echohl Comment | echo "Detected SystemC file" | echohl None
