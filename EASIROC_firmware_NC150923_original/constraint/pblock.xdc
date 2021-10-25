## Create pblocks
## a pair of FF are grouped in Synchronizers for Buffers of ADC, MHTDC, and Scaler

#Scaler
create_pblock pblock_Scaler_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncRptr0] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncRptr0] -add {SLICE_X8Y154:SLICE_X9Y155}
create_pblock pblock_Scaler_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncRptr1] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncRptr1] -add {SLICE_X10Y149:SLICE_X11Y149}
create_pblock pblock_Scaler_DB_SyncWprt0
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncWprt0] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncWprt0] -add {SLICE_X14Y156:SLICE_X15Y156}
create_pblock pblock_Scaler_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_Scaler_DB_SyncWptr1] [get_cells -quiet [list {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {Scaler_0/DoubleBuffer_0/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_Scaler_DB_SyncWptr1] -add {SLICE_X22Y154:SLICE_X23Y154}

#ADC HG1
create_pblock pblock_ADCHG1_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr0] -add {SLICE_X20Y155:SLICE_X21Y156}
create_pblock pblock_ADCHG1_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncRptr1] -add {SLICE_X18Y159:SLICE_X19Y159}
create_pblock pblock_ADCHG1_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr0] -add {SLICE_X18Y157:SLICE_X19Y158}
create_pblock pblock_ADCHG1_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG1_DB_SyncWptr1] -add {SLICE_X16Y159:SLICE_X17Y159}

#ADC HG2
create_pblock pblock_ADCHG2_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr0] -add {SLICE_X20Y159:SLICE_X21Y160}
create_pblock pblock_ADCHG2_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncRptr1] -add {SLICE_X14Y150:SLICE_X15Y150}
create_pblock pblock_ADCHG2_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr0] -add {SLICE_X16Y154:SLICE_X17Y155}
create_pblock pblock_ADCHG2_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_HG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCHG2_DB_SyncWptr1] -add {SLICE_X14Y144:SLICE_X15Y144}

#ADC LG1
create_pblock pblock_ADCLG1_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr0] -add {SLICE_X14Y141:SLICE_X15Y142}
create_pblock pblock_ADCLG1_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncRptr1] -add {SLICE_X18Y154:SLICE_X19Y154}
create_pblock pblock_ADCLG1_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr0] -add {SLICE_X14Y153:SLICE_X15Y154}
create_pblock pblock_ADCLG1_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG1/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG1_DB_SyncWptr1] -add {SLICE_X18Y150:SLICE_X19Y150}

#ADC LG2
create_pblock pblock_ADCLG2_DB_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr0] -add {SLICE_X16Y156:SLICE_X17Y157}
create_pblock pblock_ADCLG2_DB_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncRptr1] -add {SLICE_X20Y152:SLICE_X21Y152}
create_pblock pblock_ADCLG2_DB_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr0] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr0] -add {SLICE_X22Y156:SLICE_X23Y157}
create_pblock pblock_ADCLG2_DB_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr1] [get_cells -quiet [list {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {ADC_0/ADC_EventBuffer_LG2/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_ADCLG2_DB_SyncWptr1] -add {SLICE_X22Y152:SLICE_X23Y152}

#MHTDC Leading Edge
create_pblock pblock_TDC_EBL_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncRptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncRptr0] -add {SLICE_X10Y142:SLICE_X11Y143}
create_pblock pblock_TDC_EBL_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncRptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncRptr1] -add {SLICE_X16Y150:SLICE_X17Y150}
create_pblock pblock_TDC_EBL_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncWptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncWptr0] -add {SLICE_X14Y147:SLICE_X15Y148}
create_pblock pblock_TDC_EBL_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBL_SyncWptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Leading/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBL_SyncWptr1] -add {SLICE_X12Y155:SLICE_X13Y155}

#MHTDC Trailing Edge
create_pblock pblock_TDC_EBT_SyncRptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncRptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncRptr0] -add {SLICE_X10Y145:SLICE_X11Y146}
create_pblock pblock_TDC_EBT_SyncRptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncRptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Rptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncRptr1] -add {SLICE_X10Y152:SLICE_X11Y152}
create_pblock pblock_TDC_EBT_SyncWptr0
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncWptr0] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[0].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncWptr0] -add {SLICE_X14Y158:SLICE_X15Y159}
create_pblock pblock_TDC_EBT_SyncWptr1
add_cells_to_pblock [get_pblocks pblock_TDC_EBT_SyncWptr1] [get_cells -quiet [list {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF1} {MHTDC_0/MHTDC_EventBuffer_Trailing/Synchronizer_Wptr/Synchronizer1bit[1].Synchronizer_0/DoubleFFSynchronizerFF2}]]
resize_pblock [get_pblocks pblock_TDC_EBT_SyncWptr1] -add {SLICE_X20Y157:SLICE_X21Y157}

#EdgeDetector L1 Trigger
create_pblock pblock_SyncEdge_L1
add_cells_to_pblock [get_pblocks pblock_SyncEdge_L1] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_L1/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_L1/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_L1] -add {SLICE_X14Y49:SLICE_X15Y50}

#EdgeDetector L2 Trigger
create_pblock pblock_SyncEdge_L2
add_cells_to_pblock [get_pblocks pblock_SyncEdge_L2] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_L2/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_L2/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_L2] -add {SLICE_X30Y44:SLICE_X31Y45}

#EdgeDetector FAST CLEAR
create_pblock pblock_SyncEdge_FASTCLEAR
add_cells_to_pblock [get_pblocks pblock_SyncEdge_FASTCLEAR] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_FAST_CLEAR/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_FAST_CLEAR/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_FASTCLEAR] -add {SLICE_X12Y41:SLICE_X13Y42}

#EdgeDetector FAST CLEAR
create_pblock pblock_SyncEdge_HOLD
add_cells_to_pblock [get_pblocks pblock_SyncEdge_HOLD] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_HOLD/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_HOLD/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_HOLD] -add {SLICE_X18Y48:SLICE_X19Y49}

#EdgeDetector IsDaqMode?
create_pblock pblock_SyncEdge_IsDaq
add_cells_to_pblock [get_pblocks pblock_SyncEdge_IsDaq] [get_cells -quiet [list TriggerManager_0/SynchEdgeDetector_IsDaqMode/Synchronizer_0/DoubleFFSynchronizerFF1 TriggerManager_0/SynchEdgeDetector_IsDaqMode/Synchronizer_0/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_IsDaq] -add {SLICE_X24Y16:SLICE_X25Y17}


#EdgeDetector AdcTdcBusy
create_pblock pblock_SyncEdge_AdcTdcBusy
add_cells_to_pblock [get_pblocks pblock_SyncEdge_AdcTdcBusy] [get_cells -quiet [list TriggerManager_0/Synchronizer_AdcTdcBusy/DoubleFFSynchronizerFF1 TriggerManager_0/Synchronizer_AdcTdcBusy/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_AdcTdcBusy] -add {SLICE_X32Y22:SLICE_X33Y23}

#EdgeDetector GathererBusy
create_pblock pblock_SyncEdge_GathererBusy
add_cells_to_pblock [get_pblocks pblock_SyncEdge_GathererBusy] [get_cells -quiet [list TriggerManager_0/Synchronizer_GathererBusy/DoubleFFSynchronizerFF1 TriggerManager_0/Synchronizer_GathererBusy/DoubleFFSynchronizerFF2]]
resize_pblock [get_pblocks pblock_SyncEdge_GathererBusy] -add {SLICE_X14Y51:SLICE_X15Y52}
