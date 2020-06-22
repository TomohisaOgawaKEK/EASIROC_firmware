/*
	20/06/15
    if you take data w/ or64, you have pedestal peak as well
   
*/

std::vector <double> GetPeakX(TH1F *h1, int maxPeaks = 4)
{
	TSpectrum *spec = new TSpectrum(maxPeaks);
    spec->Search(h1, 3, "new");
    int getPeaks = spec->GetNPeaks();
    if ( getPeaks!=4 ) cerr << "\n\n\nfail: " << h1->GetName() << " \n\n\n" << endl;
    double* xpeaks = spec->GetPositionX();
    for (int j=0; j<4; ++j) {
       	for (int k=j+1; k<4; ++k) {
        	if (xpeaks[j] > xpeaks[k]) {
        		double tmp =  xpeaks[j];
        		xpeaks[j] = xpeaks[k];
        		xpeaks[k] = tmp;
      		}
    	}
  	}        
	std::vector <double> ret;
	ret.push_back(xpeaks[1]);
	ret.push_back(xpeaks[2]);
	ret.push_back(xpeaks[3]);
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

void anal_incalib()
{
	gStyle->SetPalette(55);

	const int NChs = 64;
	TFile *f[99];
	TTree *t[99];
	for (int i=0; i<NChs; i++) {
		stringstream str;
		//str << "../data_calib/sumcalib_chan" << i << ".root" <<ends;
		str << "../data_store/easiroc200620_calib_farm3_KEK15/sumcalib_chan" << i << ".root" <<ends;
		f[i] = new TFile(str.str().data());
		t[i] = (TTree*) f[i]->Get("tree");
	}

	TH1F *h1[99];
	TGraphErrors *ge1[99];

    // 20/06/15
    // Artix7 pin 3.3 V
	// default register values 4700, 470 ohm
    //double inpQ[3] = {3.186, 29.07, 31.68}; // [pQ]
    double inpQ[3] = {3.186*1E+3, 29.07*1E+3, 31.68*1E+3}; // [fQ]
    //double inpQ[3] = {13.194*1E+3, 19.80*1E+3, 33.003*1E+3}; // [fQ]

	TH2F *h2_fQADC = new TH2F("h2_fQADC","h2_fQADC",
                              64,0,64, 10,0,10);
	TCanvas *cADC[2];
    cADC[0] = new TCanvas("cADC0","cADC0",1200,550);
	cADC[0]->Divide(8,4);
    cADC[1] = new TCanvas("cADC1","cADC1",1200,550);
	cADC[1]->Divide(8,4);

    TCanvas *cLine[2];
    cLine[0] = new TCanvas("cLine0","cLine0",1200,550);
	cLine[0]->Divide(8,4);
    cLine[1] = new TCanvas("cLine1","cLine1",1200,550);
    cLine[1]->Divide(8,4);

    for (int i=0; i<NChs; i++) {
		cADC[i/32]->cd(1+i%32);
		gPad->SetRightMargin(0.01);

		stringstream nam, str, cut;
        nam << "h1_" << i << ends;
		str << "adc>>h1_" << i << "(1000,100,4100)" << ends;
		//str << "adc:ch>>h2_" << i << "(70,-5,65,1000,-100,4000)" << ends;
		cut << "ch==" << i << ends;
		t[i]->Draw(str.str().data(),cut.str().data(),"col");

		h1[i] = (TH1F*)gROOT->FindObject(nam.str().data());
		std::vector <double> xpeaks = GetPeakX(h1[i]);
	
		cLine[i/32]->cd(1+i%32);
		gPad->SetRightMargin(0.01);

        ge1[i] = new TGraphErrors();
		SetGraph(ge1[i],inpQ,xpeaks);
		ge1[i]->Draw("ape");
		ge1[i]->Fit("pol1","Q");

		double fQADC = 1./((TF1*) ge1[i]->GetFunction("pol1"))->GetParameter(1);
		cerr << fQADC << endl;
		h2_fQADC->SetBinContent(i+1,1,fQADC);
	}

    TCanvas *c4 = new TCanvas("c4","c4",550,550);
	h2_fQADC->SetMaximum(14);
	h2_fQADC->SetMinimum(12);
	h2_fQADC->Draw("colz");
	h2_fQADC->Draw("text90 same");

}
