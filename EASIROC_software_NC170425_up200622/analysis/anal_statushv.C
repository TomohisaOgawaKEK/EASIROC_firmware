

std::vector <double> GetHVvalues(TString fname = "../status")
{
   ifstream fin (fname);
   const int kMaxLen = 1024;
   char temp[kMaxLen];
   int line=0;

//--
//:HV: 54.904
//:current: 5.86
//:InputDAC:
//- 0.075

   double valHV=0;
   double adjHV[64]={};
   int ch=0;

   while ( fin.getline(temp,kMaxLen) ) {
      //cerr << temp << " " << endl;
      if ( temp[1] == '-' ) continue;
      if ( line==0 ) {
         char tmpval[9]={};
         strncpy( tmpval, temp+5, 8); //strの先頭+3の位置から5文字をtにコピー      
         valHV = atof( tmpval  );
      }
      if ( temp[1] == ' ' ) {
         char tmpval[9]={}; 
         strncpy( tmpval, temp+2, 5); //strの先頭+3の位置から5文字をtにコピー      
         adjHV[ch] = atof( tmpval  );
         ch++;
      }
      //cerr << line << " " << temp << "   " << endl;
      line++;
	}

	std::vector <double> retHV;

    //cerr << "HV = " << valHV << endl;
	for (int i=0; i<64; i++) {
        retHV.push_back(adjHV[i]);        
		//cerr << i << " " << adjHV[i] << endl;
	}
    retHV.push_back(valHV);
    return retHV;
}


void anal_statushv()
{
    const int NFs = 70;
	std::vector <std::vector <double>> getHV;

    for (int i=1; i<NFs; i++) {
        stringstream str;
        str << "../status_store/easiroc200622_status_inDAC280_KEK15/inputDAC" << i << ".yml" <<ends;
        std::vector <double> retHV = GetHVvalues(str.str().data());
        //cerr << "retHV size = " << retHV.size() << endl;
    	getHV.push_back( retHV );
	}

    TGraphErrors *ge1[99];	  
    int stt = 0;
    int end =64;

    for (int i=stt; i<end+1; i++) {
        cerr << "ch = " << i << endl; 
        ge1[i] = new TGraphErrors();
        for (int j=0; j<getHV.size(); j++) {
            cerr << "point = " << getHV[j][i] << endl;
            ge1[i] ->SetPoint(ge1[i]->GetN(), j, getHV[j][i] );    
        } 
	}

    TCanvas *cHV[2];
    cHV[0] = new TCanvas("cHV0","cHV0",1500,700);
    cHV[0]->Divide(8,4);
    cHV[1] = new TCanvas("cHV1","cHV1",1500,700);
    cHV[1]->Divide(8,4);

    for (int i=stt; i<end; i++) {
        cHV[i/32]->cd(1+i%32);
        //gPad->SetRightMargin(0.01);
        //ge1[i]->GetYaxis()->SetRangeUser(0,0.5);
        ge1[i]->GetYaxis()->SetRangeUser(0,5);
        ge1[i]->Draw("ap*");
    }

   TCanvas *cGHV = new TCanvas("cGHV","cGHV",700,700);
   ge1[64]->GetYaxis()->SetRangeUser(48,62);
   ge1[64]->Draw("ap*");
} 



