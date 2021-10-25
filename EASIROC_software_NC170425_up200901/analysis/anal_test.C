/*
	20/06/15
    if you take data w/ or64, you have pedestal peak as well
   
*/

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
      if (xpeaks[j]<900) continue;
	   ret.push_back(xpeaks[j]);
      //int ith = tmp->FindBin( xpeaks[j] );
      //int yval= tmp->GetBinContent( ith ) / rebin;
      //ret.push_back( std::pair <double, double>(xpeaks[j],yval) );
   }
	return ret;
}

void SetGraph(TGraphErrors *ge, double *inpQ, std::vector <double> xpeaks)
{
	ge->SetPoint     (0, inpQ[0], xpeaks[0]);
    ge->SetPointError(0, inpQ[0]*0.01, 4./sqrt(12.));
    ge->SetPoint     (1, inpQ[1], xpeaks[1]);
    ge->SetPointError(1, inpQ[1]*0.01, 4./sqrt(12.));
    ge->SetPoint     (2, inpQ[2], xpeaks[2]);
    ge->SetPointError(2, inpQ[2]*0.01, 4./sqrt(12.));
}

//void anal_incalib()
//void anal_incalib(TString dir = "../data_store/easiroc200620_farm1_calib_KEK15/")
//void anal_incalib(TString dir = "../data_store/easiroc200620_farm3_calib_KEK15/")
//void anal_incalib(TString dir = "../data_store/easiroc200617_farm1_calib_delay39_UT18/")
//void anal_incalib(TString dir = "../data_store/easiroc200617_farm1_calib_delay39_KEK15/")
void anal_test(TString dir = "../data/")
{
	gStyle->SetPalette(55);

    // 20/06/15
    // Artix7 pin 3.3 V
    // default register values 4700, 470 ohm
    //double inpQ[3] = {3.186, 29.07, 31.68}; // [pQ]
    //double inpQ[3] = {3.186*1E+3, 29.07*1E+3, 31.68*1E+3}; // [fQ]
    double inpQ[3] = {13.194*1E+3, 19.80*1E+3, 33.003*1E+3}; // [fQ]

	const int NChs = 36;
	TFile *f[99];
	TTree *t[99];
	TH1F *h1[99];
	for (int i=0; i<NChs; i++) {
		stringstream str;
		//str << "../data_calib/sumcalib_chan" << i << ".root" <<ends;
		str << dir << "calib_chan" << i << "_qptn0.root" <<ends;
		f[i] = new TFile(str.str().data());
		t[i] = (TTree*) f[i]->Get("tree");
	}
/*
    stringstream str3;
    str3 << dir << "summary.txt" << ends;
    ofstream outf(str3.str().data());

    // -----
	TH1F *h1[99];
	TGraphErrors *ge1[99];

	TH2F *h2_fQADC = new TH2F("h2_fQADC","h2_fQADC",
                              64,0,64, 10,0,10);
*/
    const double canW = 1500;
    const double canH =  800;

	TCanvas *cADC[2];
    cADC[0] = new TCanvas("cADC0","cADC0",canW,canH);
	cADC[0]->Divide(8,4);
    cADC[1] = new TCanvas("cADC1","cADC1",canW,canH);
	cADC[1]->Divide(8,4);

	TGraph * g = new TGraph();

    for (int i=2; i<NChs; i++) {
      cADC[0]->cd(i);
			stringstream nam, str, cut;
          nam << "h1_" << i << ends;
		str << "adc>>h1_" << i << "(1000,900,1900)" << ends;
		//str << "adc:ch>>h2_" << i << "(70,-5,65,1000,-100,4000)" << ends;
		cut << "ch==1" << ends;
		t[i]->Draw(str.str().data(),cut.str().data(),"col");

		h1[i] = (TH1F*)gROOT->FindObject(nam.str().data());
     h1[i] ->Smooth(50);
		std::vector <double> xpeaks = GetPeakX(h1[i]);
        h1[i]->Draw("same");
     cerr << xpeaks[0 ] << endl;
     g->SetPoint(g->GetN(), i, xpeaks[0]);
/*	
		cLine[i/32]->cd(1+i%32);
		gPad->SetRightMargin(0.01);

        ge1[i] = new TGraphErrors();
		SetGraph(ge1[i],inpQ,xpeaks);
		ge1[i]->Draw("ape");
		TF1 *poly1 = new TF1("poly1","pol1(0)",0,5000);
//   1  p0           7.61562e+02   1.97567e+01   2.28468e-02  -8.18074e-06
//   2  p1           6.30226e-02   1.09307e-03   1.04045e-06   1.61978e-01
      poly1->SetParameter(0, 7.61562e+02);
      poly1->SetParameter(1, 6.30226e-02);
		ge1[i]->Fit(poly1,"Q");

		double fQADC = 1./((TF1*) ge1[i]->GetFunction("poly1"))->GetParameter(1);
        double fQADCEr = 1./((TF1*) ge1[i]->GetFunction("poly1"))->GetParError(1);
		cerr << fQADC << endl;
        outf << i << " " << fQADC << " " << fQADCEr << endl;
	//	h2_fQADC->SetBinContent(i+1,1,fQADC);
*/
	}
    TCanvas *c4 = new TCanvas("c4","c4",550,550);
	g->Draw("ap*");
/*
    outf.close();
    cLine[0]->Print(dir+"pulsecalib1.pdf");
    cLine[1]->Print(dir+"pulsecalib2.pdf");

    TCanvas *c4 = new TCanvas("c4","c4",550,550);
	h2_fQADC->SetMaximum(14);
	h2_fQADC->SetMinimum(12);
	h2_fQADC->Draw("colz");
	h2_fQADC->Draw("text90 same");
*/
}
