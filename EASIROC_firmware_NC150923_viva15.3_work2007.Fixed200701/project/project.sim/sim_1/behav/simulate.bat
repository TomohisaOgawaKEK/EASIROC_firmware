@echo off
set xv_path=C:\\Xilinx\\Vivado\\2014.3.1\\bin
call %xv_path%/xsim TriggerManager_test_behav -key {Behavioral:sim_1:Functional:TriggerManager_test} -tclbatch TriggerManager_test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
