@echo off
set xv_path=C:\\Xilinx\\Vivado\\2014.3.1\\bin
call %xv_path%/xsim UsrClkOut_test_behav -key {Behavioral:sim_1:Functional:UsrClkOut_test} -tclbatch UsrClkOut_test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
