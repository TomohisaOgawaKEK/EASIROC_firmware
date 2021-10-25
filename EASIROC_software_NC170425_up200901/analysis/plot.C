

void plot()
{
	const int nfs = 10;
	TString dir[nfs];
	dir[0] = "../data_store/easiroc200623_farm3_led_temp20_SAMTEC1.0mNo1_Ecable0.5mNo1213_KEK15/";
	dir[1] = "../data_store/easiroc200623_farm3_led_temp20_SAMTEC2.0mNo1_Ecable0.5mNo1213_KEK15/";
	dir[2] = "../data_store/easiroc200623_farm3_led_temp20_SAMTEC1.0mNo1_Ecable1.0mNo12_KEK15/";
	dir[3] = "../data_store/easiroc200623_farm3_led_temp20_SAMTEC2.0mNo1_Ecable1.0mNo12_KEK15/";
	dir[4] = "../data_store/easiroc200624_farm1_led_temp20_SAMTEC1.0mNo1_Ecable1.0mNo78_UT18/";
	dir[5] = "../data_store/easiroc200624_farm1_led_temp20_SAMTEC1.0mNo1_Ecable0.5mNo1011_UT18/";
	dir[6] = "../data_store/easiroc200624_farm1_led_temp20_SAMTEC1.0mNo1_Ecable1.0mNo78_UT18/";
	dir[7] = "../data_store/easiroc200624_farm1_led_temp20_SAMTEC1.0mNo1_Ecable0.5mNo1011_UT18/";
	dir[8] = "../data_store/easiroc200625_farm1_led_temp20_10pts_SAMTEC1.0mNo1_Ecable0.5mNo1011_UT18/";
	dir[9] = "../data_store/easiroc200625_farm1_led_temp20_10pts_SAMTEC1.0mNo1_Ecable1.0mNo12_UT18/";

	ifstream ifs[nfs];
	for (int i=0; i<nfs; i++) {
		ifs[i].open(dir[i]+"summary.txt");
		if (i==4) ifs[i].open(dir[i]+"summary_w_correction.txt");
		if (i==5) ifs[i].open(dir[i]+"summary_w_correction.txt");
		if (i==6) ifs[i].open(dir[i]+"summary_wo_correction.txt");
		if (i==7) ifs[i].open(dir[i]+"summary_wo_correction.txt");
	}

	TGraphErrors *ge[nfs];
   for (int i=0; i<nfs; i++) {
		ge[i] = new TGraphErrors();
		ge[i]->SetMarkerStyle(20);
		ge[i]->GetXaxis()->SetLimits(-2,65);
		ge[i]->SetMinimum(50);
		ge[i]->SetMaximum(54);

		double a, b, c;
		while ( ifs[i] >> a >> b >> c ) {
			cerr << a << " " << b << endl;
			int nth = ge[i]->GetN();
			ge[i]->SetPoint     (nth, a, b);
			ge[i]->SetPointError(nth, 0, c);
		}
	}

    TCanvas *c1 = new TCanvas("c1","c1",800,800);

	ge[0]->GetXaxis()->SetLimits(-2,65);
	ge[0]->Draw("ape");

	ge[1]->SetLineColor(2);
	ge[1]->SetMarkerColor(2);
	ge[1]->Draw(" pe");

	ge[2]->SetLineColor(4);
	ge[2]->SetMarkerColor(4);
	ge[2]->Draw(" pe");

	ge[3]->SetLineColor(kGreen+1);
	ge[3]->SetMarkerColor(kGreen+1);
	ge[3]->Draw(" pe");

    TCanvas *c2 = new TCanvas("c2","c2",800,800);

	ge[4]->GetXaxis()->SetLimits(-2,65);
    ge[4]->Draw("ape");

	ge[5]->SetLineColor(2);
	ge[5]->SetMarkerColor(2);
    ge[5]->Draw(" pe");

    TCanvas *c3 = new TCanvas("c3","c3",800,800);

    ge[6]->GetXaxis()->SetLimits(-2,65);
    ge[6]->Draw("ape");

    ge[7]->SetLineColor(2);
    ge[7]->SetMarkerColor(2);
    ge[7]->Draw(" pe");

    TCanvas *c4 = new TCanvas("c4","c4",800,800);

    ge[8]->GetXaxis()->SetLimits(-2,65);
    ge[8]->Draw("ape");

    ge[9]->SetLineColor(2);
    ge[9]->SetMarkerColor(2);
    ge[9]->Draw(" pe");
}
