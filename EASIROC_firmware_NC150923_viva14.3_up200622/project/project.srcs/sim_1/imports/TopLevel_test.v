// =========================================================================
// $Name:  $
// $Id: $
// =========================================================================
//     All proprietary rights accoding to this source code belong to 
//                 Shinshu Univ. Hign Energy Physics Lab.
//
//                (C) COPYRIGHT 2019 SHINSHU UNIVERSITY.
//                          ALL RIGHTS RESERVED
//
// File         : tb_top.v
// Author       : Sato,Hisao
// Date created : Oct.27,2019
// Abstract     : EasirocModule -Chikuma version- test bench top
// 
// =========================================================================
`timescale          1ns/100ps

module tb_top ;

   reg clk ;
   reg rst_sys ;
   integer ncycle ;
   
   initial begin
      clk = 1'b0 ;
      rst_sys = 1'b0 ;
      ncycle = 0 ;
      #(`TCYCLE*4) rst_sys = 1'b1 ;
   end
   
//   assign u_uflD_top.u_uflD_clock.SW_RSTn = ~rst_sys ;

   always #(`TCYCLE/2) clk <= ~clk ;
   
   always @(posedge clk) begin
      ncycle = ncycle + 1 ;
      if (ncycle> `MAX_NCYCLE) begin
         $display("finish at MAX_NCYCLE") ;
         //$fclose(tb_top.u_TopLevel.SiTCP.SiTCP.mcd);
         $finish ;
      end
   end
   


   // easiroc chip1 port ------------
   //reg              SROUT_SR_C1;
   //reg              SROUT_READ_C1;
   wire             SROUT_SR_C1;
   wire             SROUT_READ_C1;
   wire             RST_SR_C1;
   wire             RST_READ_C1;
   wire             RST_PA_C1;
   wire             SRIN_SR_C1;
   wire             SRIN_READ_C1;
   wire             CLK_SR_C1;
   wire             CLK_READ_C1;
   wire             LOAD_SC_C1;
   wire             SELECT_SC_C1;
   wire             PWR_ON_C1;
   wire             HOLD_ASIC_C1;
   wire             VAL_E_C1;
   wire             RAZ_CH_C1;
   // ADC port chip1-------------
   wire  [12:1]     ADC_HG_C1;
   wire  [12:1]     ADC_LG_C1;
   wire             ADC_HG_OTA_C1;
   wire             ADC_LG_OTA_C1;
   reg              DIGITAL_LINE_C1;
   reg              OR32_C1;
   wire  [31:0]     DISCRI_BUS_C1;
   wire             ADC_CLK_HG_C1;
   wire             ADC_CLK_LG_C1;
   // easiroc chip2 port ------------
   //reg              SROUT_SR_C2;
   //reg              SROUT_READ_C2;
   wire             SROUT_SR_C2;
   wire             SROUT_READ_C2;
   wire             RST_SR_C2;
   wire             RST_READ_C2;
   wire             RST_PA_C2;
   wire             SRIN_SR_C2;
   wire             SRIN_READ_C2;
   wire             CLK_SR_C2;
   wire             CLK_READ_C2;
   wire             LOAD_SC_C2;
   wire             SELECT_SC_C2;
   wire             PWR_ON_C2;
   wire             HOLD_ASIC_C2;
   wire             VAL_E_C2;
   wire             RAZ_CH_C2;
   // ADC port chip2 -------------
   wire  [12:1]     ADC_HG_C2;
   wire  [12:1]     ADC_LG_C2;
   wire             ADC_HG_OTA_C2;
   wire             ADC_LG_OTA_C2;
   reg              DIGITAL_LINE_C2;
   reg              OR32_C2;
   wire  [31:0]     DISCRI_BUS_C2;
   wire             ADC_CLK_HG_C2;
   wire             ADC_CLK_LG_C2;
   // I/O port ----------
   wire  [6:1]      IN_FPGA;
   reg              PWR_RST;
   wire  [5:1]      OUT_FPGA;
   //wire   [5:1]     TEST;
   // HV control---------------
   wire             CS_DAC;
   wire             SCK_DAC;
   wire             SDI_DAC;
   wire             HV_EN;
   // MADC control-------------
   wire             SCK_MADC;
   wire             CS_MADC;
   wire             DIN_MADC;
   reg              DOUT_MADC;
   wire  [3:0]      MUX_EN;
   wire  [3:0]      MUX;
   // SPI config------------------
   wire             SPI_SCK;
   reg              SPI_MISO;
   wire             SPI_MOSI;
   wire             SPI_SS;
   wire             PROG_B_ON;
   // test charge
   wire             CAL1;
   wire             CAL2;
   // SiTCP port ----------
   //reg              ETH_MDIO;
   wire             ETH_MDIO;
   wire             ETH_MDC;
   wire             ETH_TX_EN;
   wire             ETH_TX_ER;
   wire  [3:0]      ETH_TXD;
   reg              ETH_RX_ER;
   reg              ETH_RX_DV;
   reg   [3:0]      ETH_RXD;
   reg              ETH_COL;
   reg              ETH_CRS;
   reg              ETH_TX_CLK;
   reg              ETH_RX_CLK;
   wire             ETH_nRST;
   wire  [2:1]      ETH_LED;
   wire             EEP_CS;
   wire             EEP_SK;
   wire             EEP_DI;
   reg              EEP_DO;
   reg   [3:0]      DIP_SW; 
   wire  [8:1]      LED;



   initial begin
      //SROUT_SR_C1 <= `LOW;
      //SROUT_READ_C1 <= `LOW;
   // ADC port chip1-------------
      //ADC_HG_C1 <={12{`LOW}};
      //ADC_LG_C1 <={12{`LOW}};
      //ADC_HG_OTA_C1 <= `LOW;
      //ADC_LG_OTA_C1 <= `LOW;
      DIGITAL_LINE_C1 <= `LOW;
      OR32_C1 <= `LOW;
   // DISCRI_BUS_C1 <={32{`LOW}};
   // easiroc chip2 port ------------
      //SROUT_SR_C2 <= `LOW;
      //SROUT_READ_C2 <= `LOW;
   // ADC port chip2 -------------
      //ADC_HG_C2 <={12{`LOW}};
      //ADC_LG_C2 <={12{`LOW}};
      //ADC_HG_OTA_C2 <= `LOW;
      //ADC_LG_OTA_C2 <= `LOW;
      DIGITAL_LINE_C2 <= `LOW;
      OR32_C2 <= `LOW;
   // DISCRI_BUS_C2 <={32{`LOW}};
   // I/O port ----------
      //IN_FPGA <={6{`LOW}};
      //IN_FPGA[4] <= 1'b0;
      //IN_FPGA[5] <= 1'b0;
      //IN_FPGA[6] <= 1'b0;
      PWR_RST <= `LOW;
   // HV control---------------
   // MADC control-------------
      DOUT_MADC <= `LOW;
   // SPI config------------------
      SPI_MISO <= `LOW;
   // test charge
   // SiTCP port ----------
      //ETH_MDIO <= `LOW;
      ETH_RX_ER <= `LOW;
      ETH_RX_DV <= `LOW;
      ETH_RXD <={4{`LOW}};
      ETH_COL <= `LOW;
      ETH_CRS <= `LOW;
      ETH_TX_CLK <= `LOW;
      ETH_RX_CLK <= `LOW;
      EEP_DO <= `LOW;
      DIP_SW<={4{`LOW}}; 
   end


   TopLevel u_TopLevel(
                       .EXTCLK50M(clk),
		       //AT93C46D
                       .EEPROM_SK(EEP_SK),
                       .EEPROM_CS(EEP_CS),
                       .EEPROM_DI(EEP_DI),
                       .EEPROM_DO(EEP_DO),
		       //PHY
                       .ETH_MDIO(ETH_MDIO),
                       .ETH_MDC(ETH_MDC),
                       .ETH_TX_EN(ETH_TX_EN),
                       .ETH_TX_ER(ETH_TX_ER),
                       .ETH_TXD(ETH_TXD),
                       .ETH_RX_ER(ETH_RX_ER),
                       .ETH_RX_DV(ETH_RX_DV),
                       .ETH_RXD(ETH_RXD),
                       .ETH_COL(ETH_COL),
                       .ETH_CRS(ETH_CRS),
                       .ETH_TX_CLK(ETH_TX_CLK),
                       .ETH_RX_CLK(ETH_RX_CLK),
                       .ETH_RSTn(ETH_nRST),
                       .ETH_LED(ETH_LED),
                       .DIP_SW(DIP_SW[0]),
                       //EASIROC chip1
                       .EASIROC1_HOLDB(HOLD_ASIC_C1),
                       .EASIROC1_RESET_PA(RST_PA_C1),
                       .EASIROC1_PWR_ON(PWR_ON_C1),
                       .EASIROC1_VAL_EVT(VAL_E_C1),
                       .EASIROC1_RAZ_CHN(RAZ_CH_C1),
		       //Slow Control
                       //.RST_SR_C1(RST_SR_C1),
                       .EASIROC1_CLK_SR(CLK_SR_C1),
                       .EASIROC1_RSTB_SR(SROUT_SR_C1),
                       .EASIROC1_SRIN_SR(SRIN_SR_C1),
                       .EASIROC1_LOAD_SC(LOAD_SC_C1),
                       .EASIROC1_SELECT_SC(SELECT_SC_C1),
		       //Read Register
                       //.RST_READ_C1(RST_READ_C1),
                       .EASIROC1_CLK_READ(CLK_READ_C1),
                       .EASIROC1_RSTB_READ(SROUT_READ_C1),
                       .EASIROC1_SRIN_READ(SRIN_READ_C1),
		       //ADC
                       .EASIROC1_ADC_CLK_HG(ADC_CLK_HG_C1),
                       .EASIROC1_ADC_DATA_HG(ADC_HG_C1),
                       .EASIROC1_ADC_OTR_HG(ADC_HG_OTA_C1),
                       .EASIROC1_ADC_CLK_LG(ADC_CLK_LG_C1),
                       .EASIROC1_ADC_DATA_LG(ADC_LG_C1),
                       .EASIROC1_ADC_OTR_LG(ADC_LG_OTA_C1),
                       .EASIROC1_TRIGGER(DISCRI_BUS_C1),

                       //EASIROC chip2
                       .EASIROC2_HOLDB(HOLD_ASIC_C2),
                       .EASIROC2_RESET_PA(RST_PA_C2),
                       .EASIROC2_PWR_ON(PWR_ON_C2),
                       .EASIROC2_VAL_EVT(VAL_E_C2),
                       .EASIROC2_RAZ_CHN(RAZ_CH_C2),
		       //Slow Control
                       //.RST_SR_C2(RST_SR_C2),
                       .EASIROC2_CLK_SR(CLK_SR_C2),
                       .EASIROC2_RSTB_SR(SROUT_SR_C2),
                       .EASIROC2_SRIN_SR(SRIN_SR_C2),
                       .EASIROC2_LOAD_SC(LOAD_SC_C2),
                       .EASIROC2_SELECT_SC(SELECT_SC_C2),
		       //Read Register
                       //.RST_READ_C2(RST_READ_C2),
                       .EASIROC2_CLK_READ(CLK_READ_C2),
                       .EASIROC2_RSTB_READ(SROUT_READ_C2),
                       .EASIROC2_SRIN_READ(SRIN_READ_C2),
		       //ADC
                       .EASIROC2_ADC_CLK_HG(ADC_CLK_HG_C2),
                       .EASIROC2_ADC_DATA_HG(ADC_HG_C2),
                       .EASIROC2_ADC_OTR_HG(ADC_HG_OTA_C2),
                       .EASIROC2_ADC_CLK_LG(ADC_CLK_LG_C2),
                       .EASIROC2_ADC_DATA_LG(ADC_LG_C2),
                       .EASIROC2_ADC_OTR_LG(ADC_LG_OTA_C2),
                       .EASIROC2_TRIGGER(DISCRI_BUS_C2),

		       // SPI FLASH
                       .SPI_SCLK(SPI_SCK),
                       .SPI_MISO(SPI_MISO),
                       .SPI_MOSI(SPI_MOSI),
                       .SPI_SS_N(SPI_SS),
                       .PROG_B_ON(PROG_B_ON),
		       //LED
                       .LED(LED),
		       //Test charge injection
                       .CAL1(CAL1),
                       .CAL2(CAL2),
                       .PWR_RST(rst_sys),
		       //Monitor ADC
                       .MUX_EN(MUX_EN),
                       .MUX(MUX),
                       .SCK_MADC(SCK_MADC),
                       .CS_MADC(CS_MADC),
                       .DIN_MADC(DIN_MADC),
                       .DOUT_MADC(DOUT_MADC),
		       //HV Control
                       .CS_DAC(CS_DAC),
                       .SCK_DAC(SCK_DAC),
                       .SDI_DAC(SDI_DAC),
                       .HV_EN(HV_EN),
		       //User I/O
                       .IN_FPGA(IN_FPGA),
                       .OUT_FPGA(OUT_FPGA),
                       .OR32_C1(OR32_C1),
                       .OR32_C2(OR32_C2),
                       .DIGITAL_LINE_C2(DIGITAL_LINE_C2),
                       .DIGITAL_LINE_C1(DIGITAL_LINE_C1)
                      );

   wire [11:0]  easiroc1_adc_hg;
   wire [11:0]  easiroc1_adc_lg;
   wire [11:0]  easiroc2_adc_hg;
   wire [11:0]  easiroc2_adc_lg;
   
   AD9220_model uHG1_AD9220(
                            .B    (ADC_HG_C1),
                            .OTR  (ADC_HG_OTA_C1),
			    .ain  (easiroc1_adc_hg),
                            .adc_clk  (ADC_CLK_HG_C1)
                           );

   AD9220_model uLG1_AD9220(
                            .B    (ADC_LG_C1),
                            .OTR  (ADC_LG_OTA_C1),
			    .ain  (easiroc1_adc_lg),
                            .adc_clk  (ADC_CLK_LG_C1)
                           );

   AD9220_model uHG2_AD9220(
                            .B    (ADC_HG_C2),
                            .OTR  (ADC_HG_OTA_C2),
			    .ain  (easiroc2_adc_hg),
                            .adc_clk  (ADC_CLK_HG_C2)
                           );

   AD9220_model uLG2_AD9220(
                            .B    (ADC_LG_C2),
                            .OTR  (ADC_LG_OTA_C2),
			    .ain  (easiroc2_adc_lg),
                            .adc_clk  (ADC_CLK_LG_C2)
                           );

   EASIROC1_READ_model u_EASIROC1_READ_model(
					     .clk_read  (CLK_READ_C1),
					     .rstb_read (SROUT_READ_C1),
					     .srin_read (SRIN_READ_C1),
					     .adc_hg    (easiroc1_adc_hg),
					     .adc_lg    (easiroc1_adc_lg)
					     );
   
   EASIROC2_READ_model u_EASIROC2_READ_model(
					     .clk_read  (CLK_READ_C2),
					     .rstb_read (SROUT_READ_C2),
					     .srin_read (SRIN_READ_C2),
					     .adc_hg    (easiroc2_adc_hg),
					     .adc_lg    (easiroc2_adc_lg)
					     );
   
   CCC_model u_CCC_model(
                         .clk_50M (clk),
                         .CYCLE_CLK(),
                         .CLK_OUT(),
                         .HOLD()
                        );

   //assign IN_FPGA[4] = 1'b0;
   //assign IN_FPGA[5] = 1'b0;
   //assign IN_FPGA[6] = 1'b0;
   
   TG_model u_TG_model(
                         .clk_50M (clk),
                         .DIN(),
                         .SYNCIN(),
                         .TSTOP(IN_FPGA[4]),
                         .ACCEPT(IN_FPGA[3]),
                         .CLEAR(),
                         .HOLD(IN_FPGA[1])
                        );

   assign IN_FPGA[2] = 1'b0;
   assign IN_FPGA[5] = 1'b0;
   assign IN_FPGA[6] = 1'b0;

   SPIROC_discri_model u1_SPIROC_discri_model(
                                               .rst_n  (rst_sys),
                                               .clk_50M(clk),
                                               .CAL    (CAL2),
                                               .discri (DISCRI_BUS_C1)
                                               );

   SPIROC_discri_model u2_SPIROC_discri_model(
                                               .rst_n  (rst_sys),
                                               .clk_50M(clk),
                                               .CAL    (CAL2),
                                               .discri (DISCRI_BUS_C2)
                                               );

//=======================================================
//   simvision file out
//=======================================================
`ifdef SHM
    initial begin
        $shm_open("test.shm") ;
        $shm_probe("AC") ;
    end
`endif
    
endmodule


