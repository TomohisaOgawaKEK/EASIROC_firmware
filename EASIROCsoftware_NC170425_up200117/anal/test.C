
{
 	float a,b;
   ifstream ifs1;
   ifstream ifs2;
   ifstream ifs3;
   ifstream ifs4;
   ifs1.open("../data/dataRun001.log");
   ifs2.open("../data/dataRun002.log");
   ifs3.open("../data/dataRun003.log");
   ifs4.open("../data/dataRun004.log");

	TGraph * tg1 = new TGraph();
	TGraph * tg2 = new TGraph();
	TGraph * tg3 = new TGraph();
	TGraph * tg4 = new TGraph();

   while ( ifs1 >> a >> b ) {
		tg1->SetPoint(tg1->GetN(),a,b);
    	cout<<"a,b="<<a<<","<<b<<endl;
  	}
   while ( ifs2 >> a >> b ) {
      tg2->SetPoint(tg2->GetN(),a,b);
      cout<<"a,b="<<a<<","<<b<<endl;
   }
   while ( ifs3 >> a >> b ) {
      tg3->SetPoint(tg3->GetN(),a,b);
      cout<<"a,b="<<a<<","<<b<<endl;
   }
   while ( ifs4 >> a >> b ) {
      tg4->SetPoint(tg4->GetN(),a,b);
      cout<<"a,b="<<a<<","<<b<<endl;
   }

	tg1->SetMarkerStyle(7);
	tg1->Draw("ap");
	tg2->SetMarkerColor(2);
	tg2->SetMarkerStyle(7);
	tg2->Draw(" p");
	tg3->SetMarkerColor(4);
	tg3->SetMarkerStyle(7);
	tg3->Draw(" p");
	tg4->SetMarkerColor(kGreen+1);
	tg4->SetMarkerStyle(7);
	tg4->Draw(" p");
}
