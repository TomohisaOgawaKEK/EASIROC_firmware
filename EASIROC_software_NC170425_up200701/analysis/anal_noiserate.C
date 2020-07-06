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
void anal_noiserate(TString dir = "../data/")
{
	SetROOT();
	gStyle->SetPalette(55);

    // 20/06/15
    // Artix7 pin 3.3 V
    // default register values 4700, 470 ohm
    //double inpQ[3] = {3.186, 29.07, 31.68}; // [pQ]
    //double inpQ[3] = {3.186*1E+3, 29.07*1E+3, 31.68*1E+3}; // [fQ]
    //double inpQ[3] = {13.194*1E+3, 19.80*1E+3, 33.003*1E+3}; // [fQ]

    // calib_ch1_trigdelay20_qptn0

	const int stt = 800;
	const int end = 900;
    const int plsptn = 0;
	std::vector <TFile*> f; // thre 
	std::vector <TTree*> t; // thre
	TH1F *h1[99][99];
	TGraphErrors *ge1[99]={};

    int findex = 0;
   	for (int i=stt; i<end; i+=2) {
 	   	stringstream str;
		str << dir << "noiserate_dac" <<  i << ".root" <<ends;
		f.push_back( new TFile(str.str().data()) );
		t.push_back( (TTree*) f[f.size()-1]->Get("rate") );
	}
    //stringstream str3;
    //str3 << dir << "summary.txt" << ends;
    //ofstream outf(str3.str().data());

    // -----
    const double canW = 1800;
    const double canH =  800;
	TCanvas *cADC[1];
    cADC[0] = new TCanvas("cADC0","cADC0",canW,canH);
	cADC[0]->Divide(8,4);
    //cADC[1] = new TCanvas("cADC1","cADC1",canW,canH);
	//cADC[1]->Divide(8,4);

    for (int i=0; i<t.size(); i++) { // file
    //for (int i=0; i<1; i++) { // file
        for (int ch=0; ch<64; ch++) {
            cADC[0]->cd( 1 + ch );
            stringstream nam, str, cut;
            nam <<       "f" << i << "_ch" << ch << ends;
            str << "rate>>f" << i << "_ch" << ch << "(10000,-1000,1000000)" << ends;
            cut << "ch=="    << ch << ends;
	        t[i]->Draw(str.str().data(),cut.str().data(),"");
            h1[i][ch] = (TH1F*)gROOT->FindObject(nam.str().data());
            double mean = h1[i][ch]->GetMean();
            cerr << mean << endl;

			if ( !ge1[ch] ) ge1[ch] = new TGraphErrors();
			int nth = ge1[ch]->GetN();
            ge1[ch]->SetPoint(nth, stt + 2*i, mean);
		}
	}

    TCanvas *cLine[2];
    cLine[0] = new TCanvas("cLine0","cLine0",canW,canH);
    cLine[0]->Divide(8,4);
    cLine[1] = new TCanvas("cLine1","cLine1",canW,canH);
    cLine[1]->Divide(8,4);

    for (int ch=0; ch<64; ch++) {
        cLine[ch/32]->cd(1+ch%32);
        gPad->SetLogy();
        ge1[ch]->Draw("ap*");
	}

    //TCanvas *c4 = new TCanvas("c4","c4",600,550);
	//ge1[0]->GetXaxis()->SetLimits(0,40);
	//ge1[0]->SetMaximum(3200);
	//ge1[0]->SetMinimum(1000);
	//h2_fQADC->Draw("colz");
	//h2_fQADC->Draw("text90 same");
	//ge1[0]->SetTitle(";Trigger Delay [x 2nsec];ADC peak");
	//ge1[0]->SetTitle(";Trigger Delay [x 4nsec];ADC peak");
	//ge1[0]->Draw("ape*");
    //ge1[1]->SetLineColor(2);
    //ge1[1]->SetMarkerColor(2);
	//ge1[1]->Draw(" pe* same");
}
