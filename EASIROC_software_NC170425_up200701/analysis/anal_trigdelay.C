/*
   
*/
#include "rootstyle.C"

std::vector <double> GetPeakX(TH1F *h1, int maxPeaks = 4)
{
    TSpectrum *spec = new TSpectrum(maxPeaks);
    spec->Search(h1, 3, "new");
    int getPeaks = spec->GetNPeaks();
    double* xpeaks = spec->GetPositionX();
    for (int j=0; j<getPeaks; ++j) {
        for (int k=j+1; k<getPeaks; ++k) {
            if (xpeaks[j] > xpeaks[k]) {
                double tmp =  xpeaks[j];
                xpeaks[j] = xpeaks[k];
                xpeaks[k] = tmp;
            }
        }
    }
    cerr << h1->GetName() << " get n peaks = " << getPeaks << endl;
   std::vector <double> ret;
   for (int j=0; j<getPeaks; ++j) {
      if (xpeaks[j]<500) continue;
       ret.push_back(xpeaks[j]);
      //int ith = tmp->FindBin( xpeaks[j] );
      //int yval= tmp->GetBinContent( ith ) / rebin;
      //ret.push_back( std::pair <double, double>(xpeaks[j],yval) );
   }
    return ret;
}

//void ()
//void (TString dir = "../data_store/easiroc200620_farm1_calib_KEK15/")
//void (TString dir = "../data_store/easiroc200620_farm3_calib_KEK15/")
//void (TString dir = "../data_store/easiroc200617_farm1_calib_delay39_UT18/")
//void anal_trigdelay(TString dir = "../data_store/data200628_farm8_calibTrigDelay_UT18/")
void anal_trigdelay(TString dir = "../data_calib/")
{
	SetROOT();
	gStyle->SetPalette(55);

    // 20/06/15
    // Artix7 pin 3.3 V
    // default register values 4700, 470 ohm
    //double inpQ[3] = {3.186, 29.07, 31.68}; // [pQ]
    //double inpQ[3] = {3.186*1E+3, 29.07*1E+3, 31.68*1E+3}; // [fQ]
    double inpQ[3] = {13.194*1E+3, 19.80*1E+3, 33.003*1E+3}; // [fQ]

    // calib_ch1_trigdelay20_qptn0

	const int stt =  2;
	const int end = 36;
    const int plsptn = 2;
	TFile *f[2][99]; // ch, delay
	TTree *t[2][99]; // ch, delay
	TH1F *h1[2][99];
	TGraphErrors *ge1[2];

    for (int x=0; x<2; x++) {
   	    for (int i=stt; i<end; i++) {
 	   	    stringstream str;
		    str << dir << "calib_ch" <<  1 + x*32 << "_trigdelay" << i << "_qptn" << plsptn << ".root" <<ends;
		    f[x][i] = new TFile(str.str().data());
		    t[x][i] = (TTree*) f[x][i]->Get("tree");
		}
	}
    //stringstream str3;
    //str3 << dir << "summary.txt" << ends;
    //ofstream outf(str3.str().data());

    // -----
    const double canW = 1800;
    const double canH =  800;
	TCanvas *cADC[2];
    cADC[0] = new TCanvas("cADC0","cADC0",canW,canH);
	cADC[0]->Divide(12,3);
    cADC[1] = new TCanvas("cADC1","cADC1",canW,canH);
	cADC[1]->Divide(12,3);
/*
    TCanvas *cLine[2];
    cLine[0] = new TCanvas("cLine0","cLine0",canW,canH);
	cLine[0]->Divide(8,4);
    cLine[1] = new TCanvas("cLine1","cLine1",canW,canH);
    cLine[1]->Divide(8,4);
*/
    for (int x=0; x<2; x++) {
		ge1[x] = new TGraphErrors();
    	int canIte = 1;

    	for (int i=stt; i<end; i++) {
		cADC[x]->cd(canIte);
		canIte++;
		//gPad->SetRightMargin(0.01);

		stringstream nam, str, cut;
        nam << "h1_ch"      << 1 + x*32 << "_delay" << i << ends;
		str << "adc>>h1_ch" << 1 + x*32 << "_delay" << i << "(1000,0,4000)" << ends;
		cut << "ch=="       << 1 + x*32 << ends;
		t[x][i]->Draw(str.str().data(),cut.str().data(),"col");

		h1[x][i] = (TH1F*)gROOT->FindObject(nam.str().data());
		std::vector <double> xpeaks = GetPeakX(h1[x][i]);
		cerr << i << " " << xpeaks.size() << " " << xpeaks[0] << endl; 
        h1[x][i]->Draw("same");

		int nth = ge1[x] ->GetN();
		ge1[x] ->SetPoint(nth, i, xpeaks[1]);
		ge1[x] ->SetPointError(nth, 0, 5/sqrt(12.));
/*	
*/
		}
	}
/*
    outf.close();
    cLine[0]->Print(dir+"pulsecalib1.pdf");
    cLine[1]->Print(dir+"pulsecalib2.pdf");
*/
    TCanvas *c4 = new TCanvas("c4","c4",600,550);
	ge1[0]->GetXaxis()->SetLimits(0,40);
	ge1[0]->SetMaximum(3200);
	ge1[0]->SetMinimum(1000);
	//h2_fQADC->Draw("colz");
	//h2_fQADC->Draw("text90 same");
	//ge1[0]->SetTitle(";Trigger Delay [x 2nsec];ADC peak");
	ge1[0]->SetTitle(";Trigger Delay [x 4nsec];ADC peak");
	ge1[0]->Draw("ape*");
    ge1[1]->SetLineColor(2);
    ge1[1]->SetMarkerColor(2);
	ge1[1]->Draw(" pe* same");
}
