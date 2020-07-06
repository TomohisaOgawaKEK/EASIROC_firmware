
void SetROOT() 
{
 	cerr << "----- CALLED: Beginning RootStyle" << endl;
    cerr << "----- ROOT" << gROOT->GetVersion() << endl;

    //int FontNum = 132;
    //int FontNum = 22;
    int FontNum = 42;
    //int FontNum = 102;

 	// Set the background color to white
 	gStyle->SetFillColor(10);
 	gStyle->SetFrameFillColor(0);
 	gStyle->SetCanvasColor(0);
 	gStyle->SetPadColor(0);
 	gStyle->SetTitleFillColor(0);
 	gStyle->SetStatColor(0);

	// Dont put a colored frame around the plots
	gStyle->SetFrameBorderMode(0);
 	gStyle->SetCanvasBorderMode(0);
 	gStyle->SetPadBorderMode(0);
 	gStyle->SetLegendBorderSize(0);
 	gStyle->SetLegendFillColor(0);
 	gStyle->SetLegendFont(FontNum);

 	// use the primary color palette
 	gStyle->SetPalette(1,0);
    gStyle->SetNumberContours(26);
 	// set the default line color for a histogram to be black
 	gStyle->SetHistLineColor(kBlack);
 	// set the default line color for a fit function to be red
 	gStyle->SetFuncColor(kRed);

 	// make the axis labels black
 	gStyle->SetLabelColor(kBlack,"xyz");

 	// set the default title color to be black
 	gStyle->SetTitleColor(kBlack);

 	// Set the pad margins
 	gStyle->SetPadBottomMargin(0.16);
 	gStyle->SetPadTopMargin   (0.05);
 	gStyle->SetPadRightMargin (0.05);
 	gStyle->SetPadLeftMargin  (0.20);

 	//set axis label and title text sizes
 	gStyle->SetTextFont(FontNum);
 	gStyle->SetTextSize(0.04);
 	gStyle->SetLabelFont(FontNum,"xyz");
 	gStyle->SetLabelSize(0.055,"xy");
 	gStyle->SetLabelOffset(0.01,"xyz");
 	gStyle->SetTitleFont(FontNum,"xyz");
 	gStyle->SetTitleSize(0.062,"xz");
 	gStyle->SetTitleSize(0.062,"y");
 	gStyle->SetTitleBorderSize(0);
 	gStyle->SetTitleOffset(1.05,"xz");
 	gStyle->SetTitleOffset(1.23,"y");

 	gStyle->SetStatX(0.92); //Stat box x position (top right hand corner)	
 	gStyle->SetStatY(0.90); //Stat box y position 		
 	gStyle->SetStatW(0.20); //Stat box width as fraction of pad size	
 	gStyle->SetStatH(0.16); //Size of each line in stat box	
 	gStyle->SetStatColor(0);//Stat box fill color

 	//gStyle->SetStatTextColor(1);	//Stat box text color
 	gStyle->SetStatStyle(0);		//Stat box fill style!
 	gStyle->SetStatFont(FontNum);  	//Stat box fond
 	//gStyle->SetStatFontSize(0.8);
 	gStyle->SetStatBorderSize(0);	//Stat box border thickness

	//  set line widths
    int lw = 2;
 	gStyle->SetFrameLineWidth(lw);
 	gStyle->SetFuncWidth(lw);
 	gStyle->SetHistLineWidth(lw);
 	gStyle->SetLineWidth(lw);
 
 	// Set the number of divisions to show
 	//gStyle->SetNdivisions(504, "xy");
 	gStyle->SetNdivisions(508, "x");
 	gStyle->SetNdivisions(505, "y");
 	gStyle->SetPadGridX(0);
 	gStyle->SetPadGridY(0);
 	gStyle->SetPadTickX(1);
 	gStyle->SetPadTickY(1);

	gStyle->SetTickLength(0.02,"xy"); 

	gStyle->SetGridColor(1);
	gStyle->SetGridStyle(3);
	gStyle->SetGridWidth(1);

 	//turn off stats
 	gStyle->SetOptStat("neMR");
 	//gStyle->SetOptStat("nemr");
 	gStyle->SetOptFit(1);
 	//gStyle->SetOptFit(0111);
 
 	//marker settings
 	gStyle->SetMarkerStyle(1);
 	gStyle->SetMarkerSize(1);
 	gStyle->SetEndErrorSize(1); 

 	gStyle->SetLineScalePS(3);
	gStyle->SetPalette(55);

    gStyle->SetCanvasDefW(700);
    gStyle->SetCanvasDefH(550);

    gStyle->SetPaintTextFormat("4.3f");
}

