/*
	20/06/15

*/

//std::vector <double> GetPeakX(TH1F *h1, int maxPeaks = 10)
std::vector <std::pair <double, double> > GetPeakX(TH1F *h1, int cutoff = 500)
{
    int maxPeaks = 10;
    TSpectrum *spec = new TSpectrum(maxPeaks);
    TH1F *tmp = new TH1F(*h1);
    int ithCut = tmp->FindBin( cutoff );
    for (int j=0; j<ithCut; ++j) {
        tmp->SetBinContent(j+1,0);
	}

    double rebin = 1;
    tmp->Rebin(rebin);
    tmp->Smooth(100);
    spec->Search(tmp, 3, "new");
    int getPeaks = spec->GetNPeaks();
    double* xpeaks = spec->GetPositionX();
    for (int j=0; j<10; ++j) {
       	for (int k=j+1; k<10; ++k) {
        	if (xpeaks[j] > xpeaks[k]) {
        		double tmp =  xpeaks[j];
        		xpeaks[j] = xpeaks[k];
        		xpeaks[k] = tmp;
      		}
    	}
  	}        
	//std::vector <double> ret;
   std::vector <std::pair <double, double> > ret;
   for (int j=0; j<10; ++j) {
      if (xpeaks[j]<500) continue;
      int ith = tmp->FindBin( xpeaks[j] );
      int yval= tmp->GetBinContent( ith ) / rebin;
      //std::pair <double, double>
      ret.push_back( std::pair <double, double>(xpeaks[j],yval) );
   }
   delete tmp;
   return ret;
}


TF1 *DoFitting(TH1F *h1, std::vector <std::pair <double, double> > peaksXY)
{
   TF1 *dgaus = new TF1("dgaus","gaus(0)+gaus(3)",        0,2000);
   TF1 *tgaus = new TF1("tgaus","gaus(0)+gaus(3)+gaus(6)",0,2000);

   int sttPeak = 1;	
   double dval = peaksXY[sttPeak+1].first - peaksXY[sttPeak+0].first;
   double chi2, Ndof;

   for (int j=0; j<50; j++) {
      //tgaus->SetParameters(peaksXY[1].second, peaksXY[1].first, dval/2.,
      //                     peaksXY[3].second, peaksXY[3].first, dval/2.);
      double mean0 = peaksXY[sttPeak].first + 0*dval + (double)j*0.1;
      double mean1 = peaksXY[sttPeak].first + 1*dval - (double)j*0.1;
      double mean2 = peaksXY[sttPeak].first + 2*dval + (double)j*0.1;
      double sigma = dval/3.;
      tgaus->SetParameters(peaksXY[sttPeak+0].second, mean0, sigma,
                           peaksXY[sttPeak+1].second, mean1, sigma,
                           peaksXY[sttPeak+2].second, mean2, sigma);
      h1->Fit(tgaus,"MNRQ","same", mean0 - sigma, mean2 + sigma);
      chi2 = tgaus->GetChisquare();
      Ndof = tgaus->GetNDF();
      double pe1 = tgaus->GetParError(1);
      double pe2 = tgaus->GetParError(4);
      double pe3 = tgaus->GetParError(7);
      //cerr << "chi2/Ndof = " << chi2/(double)Ndof << endl;
      if ( pe1 < 1.0 && 
           pe2 < 1.0 && 
           pe3 < 1.0 && 
           0.5 < chi2/(double)Ndof && 
           chi2/(double)Ndof < 5.0 ) break;
   }
   cerr << "dval = " << dval << ", chi2/Ndof = " << chi2/(double)Ndof << endl;
   tgaus->SetLineColor(4);
   return tgaus;
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


void anal_fingers()
{
	gStyle->SetPalette(55);

	TFile *f[99];
	TTree *t[99];
	const int sttCh = 5;
	const int NChs = 64;
    double voltage[6] = {56.60, 56.80, 57.00, 57.20, 57.40 ,57.60};

	for (int i=0; i<6; i++) {
		stringstream str;
		str << "../data/tmp" << std::fixed << std::setprecision(2) << voltage[i] << ".root" <<ends;
		//str << "../data/tmp012.root" <<ends;
		f[i] = new TFile(str.str().data());
		t[i] = (TTree*) f[i]->Get("tree");
	}


	TH1F *h1[99][99];
	TGraphErrors *ge[99];
    TLine *line[99][99];

    // 20/06/15
    // Artix7 pin 3.3 V
	// default register values 4700, 470 ohm
    //double inpQ[3] = {3.186, 29.07, 31.68}; // [pQ]
    //double inpQ[3] = {3.186*1E+3, 29.07*1E+3, 31.68*1E+3}; // [fQ]
    //double inpQ[3] = {13.194*1E+3, 19.80*1E+3, 33.003*1E+3}; // [fQ]

	TH2F *h2_Vbd = new TH2F("h2_Vbd","h2_Vbd",
                              64,0,64, 10,0,10);
	TH2F *h2_VbdEr = new TH2F("h2_VbdEr","h2_VbdEr",
                              64,0,64, 10,0,10);

    TCanvas *cADC[6][2];

    double cutoff[2] = {860, 800};

    for (int n=0; n<6; n++) {

        stringstream str1, str2;
        str1 << "can_f" << n << "_chip1" <<ends;
        str2 << "can_f" << n << "_chip2" <<ends;
        cADC[n][0] = new TCanvas(str1.str().data(),str1.str().data(),1500,700);
        cADC[n][0]->Divide(8,4);
        cADC[n][1] = new TCanvas(str2.str().data(),str2.str().data(),1500,700);
        cADC[n][1]->Divide(8,4);

        for (int i=sttCh; i<NChs; i++) {

            cADC[n][i/32]->cd(1+i%32);
    		gPad->SetRightMargin(0.01);

			stringstream nam, str, cut;
        	nam << "h_f" << n << "_ch" << i << ends;
			//str << "adc>>h1_" << i << "(600,700,1300)" << ends;
			str << "adc>>h_f" << n << "_ch" << i << "(400,700,1100)" << ends;
			//str << "adc:ch>>h2_" << i << "(70,-5,65,1000,-100,4000)" << ends;
			cut << "ch==" << i << ends;

			t[n]->Draw(str.str().data(),cut.str().data(),"");

			h1[n][i] = (TH1F*)gROOT->FindObject(nam.str().data());
			h1[n][i]->SetMaximum(2000);

			//std::vector <double> xpeaks = GetPeakX(h1[i]);
      		std::vector <std::pair <double, double> > peaksXY = GetPeakX( h1[n][i], cutoff[i/32] );
      		h1[n][i]->Draw("same");
            
		    int NPeaks = peaksXY.size(); 

            cerr << "channel = " << i << endl;
            for (int j=0; j<NPeaks; j++) {
      	        line[i][j] = new TLine(peaksXY[j].first, 0, peaksXY[j].first, peaksXY[j].second);
      	        line[i][j]->SetLineWidth(1);
      	        line[i][j]->SetLineColor(2);
      	        line[i][j]->Draw("same");
   	        }

            if ( NPeaks<3 ) continue;
  
            TF1 *tgaus = DoFitting(h1[n][i],peaksXY);
	  		double p1 = tgaus->GetParameter(1);
	      	double p2 = tgaus->GetParameter(4);
	      	double p3 = tgaus->GetParameter(7);
	      	double pe1 = tgaus->GetParError(1);
	      	double pe2 = tgaus->GetParError(4);
	      	double pe3 = tgaus->GetParError(7);
	      	double d1 = p2 - p1;
      	    double d2 = p3 - p2;
      	    double de1= sqrt(pe2*pe2+pe1*pe1);
      	    double de2= sqrt(pe3*pe3+pe2*pe2);
      	    //tgaus->Print();
		    //cerr << " " << d1 << " " << d2 << endl;
		    tgaus->Draw("same");

		    if (n==0) {
			    ge[i] = new TGraphErrors();
		    }
		    int nth = ge[i]->GetN();
		    ge[i]->SetPoint     (nth, voltage[n], (d1 + d2)/2.);
		    ge[i]->SetPointError(nth,       0.01, (de1+de2)/2.);
	    }
	}


    TCanvas *cVbd[2];
    cVbd[0] = new TCanvas("cVbd0","cVbd0",1200,550);
    cVbd[0]->Divide(8,4);
    cVbd[1] = new TCanvas("cVbd1","cVbd1",1200,550);
    cVbd[1]->Divide(8,4);

	TF1 *f2 = new TF1("f2","(x+[0])*[1]",0,100);

    for (int i=sttCh; i<NChs; i++) {
        cVbd[i/32]->cd(1+i%32);
        gPad->SetRightMargin(0.01);
        ge[i]->Draw("ape");
        ge[i]->GetXaxis()->SetLimits(50,58);
        ge[i]->GetYaxis()->SetRangeUser(0,40);

        f2->SetParameters(-52.5,6.0);
    	ge[i]->Fit(f2,"RMQ","same",0,100);
        //((TF1*) ge[i]->GetFunction("f2"))->SetLineColor(51+i);
        double p0 = ((TF1*) ge[i]->GetFunction("f2"))->GetParameter(0);
        double pe0 = ((TF1*) ge[i]->GetFunction("f2"))->GetParError(0);
        h2_Vbd->SetBinContent(i+1,1,-p0);
        h2_VbdEr->SetBinContent(i+1,1,pe0);
    }


    TCanvas *c4 = new TCanvas("c4","c4",850,850);
    h2_Vbd->SetMaximum(54);
    h2_Vbd->SetMinimum(51);
    h2_Vbd->Draw("colz");
    h2_Vbd->Draw("text90 same");
    TCanvas *c5 = new TCanvas("c5","c5",850,850);
    h2_VbdEr->SetMaximum(1);
    h2_VbdEr->SetMinimum(0);
    h2_VbdEr->Draw("colz");
    h2_VbdEr->Draw("text90 same");

}
