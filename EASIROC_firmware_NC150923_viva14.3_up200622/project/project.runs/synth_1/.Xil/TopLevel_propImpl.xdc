set_property SRC_FILE_INFO {cfile:C:/Users/owner/Downloads/sfgd_vivadoFPGA/EASIROC_FPGA/EASIROC_firmware_NC150923_viva14.3_work2006/constraint/io.xdc rfile:../../../../constraint/io.xdc id:1} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/owner/Downloads/sfgd_vivadoFPGA/EASIROC_FPGA/EASIROC_firmware_NC150923_viva14.3_work2006/constraint/pblock.xdc rfile:../../../../constraint/pblock.xdc id:2} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/owner/Downloads/sfgd_vivadoFPGA/EASIROC_FPGA/EASIROC_firmware_NC150923_viva14.3_work2006/constraint/timing.xdc rfile:../../../../constraint/timing.xdc id:3} [current_design]
set_property src_info {type:XDC file:1 line:80 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC1_ADC_DATA_HG]
set_property src_info {type:XDC file:1 line:81 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC1_ADC_DATA_LG]
set_property src_info {type:XDC file:1 line:82 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC1_ADC_OTR_HG]
set_property src_info {type:XDC file:1 line:83 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC1_ADC_OTR_LG]
set_property src_info {type:XDC file:1 line:165 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC2_ADC_DATA_HG]
set_property src_info {type:XDC file:1 line:166 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC2_ADC_DATA_LG]
set_property src_info {type:XDC file:1 line:167 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC2_ADC_OTR_HG]
set_property src_info {type:XDC file:1 line:168 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports EASIROC2_ADC_OTR_LG]
set_property src_info {type:XDC file:1 line:211 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports SPI_SCLK]
set_property src_info {type:XDC file:1 line:212 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports SPI_SS_N]
set_property src_info {type:XDC file:1 line:213 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports SPI_MOSI]
set_property src_info {type:XDC file:1 line:214 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports SPI_MISO]
set_property src_info {type:XDC file:1 line:215 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB true [get_ports PROG_B_ON]
set_property src_info {type:XDC file:2 line:5 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_Scaler_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncRptr0] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncRptr0] -add {SLICE_X8Y154:SLICE_X9Y155}
set_property src_info {type:XDC file:2 line:8 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_Scaler_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncRptr1] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncRptr1] -add {SLICE_X10Y149:SLICE_X11Y149}
set_property src_info {type:XDC file:2 line:11 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_Scaler_DB_SyncWprt0
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncWprt0] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncWprt0] -add {SLICE_X14Y156:SLICE_X15Y156}
set_property src_info {type:XDC file:2 line:14 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_Scaler_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncWptr1] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncWptr1] -add {SLICE_X22Y154:SLICE_X23Y154}
set_property src_info {type:XDC file:2 line:19 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG1_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr0] -add {SLICE_X20Y155:SLICE_X21Y156}
set_property src_info {type:XDC file:2 line:22 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG1_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr1] -add {SLICE_X18Y159:SLICE_X19Y159}
set_property src_info {type:XDC file:2 line:25 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG1_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr0] -add {SLICE_X18Y157:SLICE_X19Y158}
set_property src_info {type:XDC file:2 line:28 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG1_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr1] -add {SLICE_X16Y159:SLICE_X17Y159}
set_property src_info {type:XDC file:2 line:33 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG2_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr0] -add {SLICE_X20Y159:SLICE_X21Y160}
set_property src_info {type:XDC file:2 line:36 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG2_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr1] -add {SLICE_X14Y150:SLICE_X15Y150}
set_property src_info {type:XDC file:2 line:39 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG2_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr0] -add {SLICE_X16Y154:SLICE_X17Y155}
set_property src_info {type:XDC file:2 line:42 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCHG2_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr1] -add {SLICE_X14Y144:SLICE_X15Y144}
set_property src_info {type:XDC file:2 line:47 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG1_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr0] -add {SLICE_X14Y141:SLICE_X15Y142}
set_property src_info {type:XDC file:2 line:50 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG1_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr1] -add {SLICE_X18Y154:SLICE_X19Y154}
set_property src_info {type:XDC file:2 line:53 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG1_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr0] -add {SLICE_X14Y153:SLICE_X15Y154}
set_property src_info {type:XDC file:2 line:56 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG1_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr1] -add {SLICE_X18Y150:SLICE_X19Y150}
set_property src_info {type:XDC file:2 line:61 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG2_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr0] -add {SLICE_X16Y156:SLICE_X17Y157}
set_property src_info {type:XDC file:2 line:64 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG2_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr1] -add {SLICE_X20Y152:SLICE_X21Y152}
set_property src_info {type:XDC file:2 line:67 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG2_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr0] -add {SLICE_X22Y156:SLICE_X23Y157}
set_property src_info {type:XDC file:2 line:70 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_ADCLG2_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr1] -add {SLICE_X22Y152:SLICE_X23Y152}
set_property src_info {type:XDC file:2 line:75 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBL_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncRptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncRptr0] -add {SLICE_X10Y142:SLICE_X11Y143}
set_property src_info {type:XDC file:2 line:78 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBL_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncRptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncRptr1] -add {SLICE_X16Y150:SLICE_X17Y150}
set_property src_info {type:XDC file:2 line:81 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBL_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncWptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncWptr0] -add {SLICE_X14Y147:SLICE_X15Y148}
set_property src_info {type:XDC file:2 line:84 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBL_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncWptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncWptr1] -add {SLICE_X12Y155:SLICE_X13Y155}
set_property src_info {type:XDC file:2 line:89 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBT_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncRptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncRptr0] -add {SLICE_X10Y145:SLICE_X11Y146}
set_property src_info {type:XDC file:2 line:92 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBT_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncRptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncRptr1] -add {SLICE_X10Y152:SLICE_X11Y152}
set_property src_info {type:XDC file:2 line:95 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBT_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncWptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncWptr0] -add {SLICE_X14Y158:SLICE_X15Y159}
set_property src_info {type:XDC file:2 line:98 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_TDC_EBT_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncWptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncWptr1] -add {SLICE_X20Y157:SLICE_X21Y157}
set_property src_info {type:XDC file:2 line:103 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_L1
add_cells_to_pblock [get_pblocks pblock_SyncEdge_L1] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_L1/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_L1/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_L1] -add {SLICE_X14Y49:SLICE_X15Y50}
set_property src_info {type:XDC file:2 line:108 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_L2
add_cells_to_pblock [get_pblocks pblock_SyncEdge_L2] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_L2/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_L2/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_L2] -add {SLICE_X30Y44:SLICE_X31Y45}
set_property src_info {type:XDC file:2 line:113 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_FASTCLEAR
add_cells_to_pblock [get_pblocks pblock_SyncEdge_FASTCLEAR] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_FAST_CLEAR/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_FAST_CLEAR/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_FASTCLEAR] -add {SLICE_X12Y41:SLICE_X13Y42}
set_property src_info {type:XDC file:2 line:118 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_HOLD
add_cells_to_pblock [get_pblocks pblock_SyncEdge_HOLD] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_HOLD/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_HOLD/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_HOLD] -add {SLICE_X18Y48:SLICE_X19Y49}
set_property src_info {type:XDC file:2 line:123 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_IsDaq
add_cells_to_pblock [get_pblocks pblock_SyncEdge_IsDaq] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_IsDaqMode/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_IsDaqMode/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_IsDaq] -add {SLICE_X24Y16:SLICE_X25Y17}
set_property src_info {type:XDC file:2 line:129 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_AdcTdcBusy
add_cells_to_pblock [get_pblocks pblock_SyncEdge_AdcTdcBusy] [get_cells -quiet [list TriggerManager_0/Synchronizer_AdcTdcBusy/DoubleFFSynchronizerFF1 TriggerManager_0/Synchronizer_AdcTdcBusy/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_AdcTdcBusy] -add {SLICE_X32Y22:SLICE_X33Y23}
set_property src_info {type:XDC file:2 line:134 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_SyncEdge_GathererBusy
add_cells_to_pblock [get_pblocks pblock_SyncEdge_GathererBusy] [get_cells -quiet [list TriggerManager_0/Synchronizer_GathererBusy/DoubleFFSynchronizerFF1 TriggerManager_0/Synchronizer_GathererBusy/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_GathererBusy] -add {SLICE_X14Y51:SLICE_X15Y52}
set_property src_info {type:XDC file:3 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter EXTCLK50M 0.002
set_property src_info {type:XDC file:3 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter ETH_RX_CLK 0.002
set_property src_info {type:XDC file:3 line:31 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter ETH_TX_CLK 0.002
