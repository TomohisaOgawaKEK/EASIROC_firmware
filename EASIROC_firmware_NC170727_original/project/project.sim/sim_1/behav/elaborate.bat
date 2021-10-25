@echo off
set xv_path=C:\\Xilinx\\Vivado\\2014.3.1\\bin
call %xv_path%/xelab  -wto 68c8138172e247eb9165dcd9af948f46 -m64 --debug typical --relax -L xil_defaultlib -L secureip --snapshot TestChargeInjection_test_behav xil_defaultlib.TestChargeInjection_test -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
