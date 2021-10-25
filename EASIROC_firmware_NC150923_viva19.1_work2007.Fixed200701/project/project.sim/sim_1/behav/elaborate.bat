@echo off
set xv_path=C:\\Xilinx\\Vivado\\2014.3.1\\bin
call %xv_path%/xelab  -wto a09aaa0935ee4069b68ed5f432374a15 -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot TriggerManager_test_behav xil_defaultlib.TriggerManager_test xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
