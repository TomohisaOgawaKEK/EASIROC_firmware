#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>

#include <TFile.h>
#include <TTree.h>
#include <TH1.h>

using namespace std;

/*
＜ビットOR演算子＞
　ビットＯＲは各ビットの同じ桁同士が論理演算された結果が得られます。
＜ビットAND演算子＞
　ビットAND演算は別名ビットマスク(ANDマスク）とも呼ばれ任意のビットを隠し、
  必要なビットだけを取り出すことが出来ます

指定しただけ，ビットをシフトします．
右シフト(>>) と 左シフト(<<)があります．演算時のビット数からはみ出た部分は捨てられます．
例：123 >> 3
01111011 >> 3 = 00001111
となって，15になります．
*/

unsigned int getBigEndian32(const char* b)
{
    return ((b[0] << 24) & 0xff000000) |
           ((b[1] << 16) & 0x00ff0000) |
           ((b[2] <<  8) & 0x0000ff00) |
           ((b[3] <<  0) & 0x000000ff);
}

bool isAdcHg(unsigned int data)
{
    return (data & 0x00680000) == 0x00000000;
}

bool isAdcLg(unsigned int data)
{
    return (data & 0x00680000) == 0x00080000;
}

bool isTdcLeading(unsigned int data)
{
    return (data & 0x00601000) == 0x00201000;
}

bool isTdcTrailing(unsigned int data)
{
    return (data & 0x00601000) == 0x00200000;
}

bool isScaler(unsigned int data)
{
    return (data & 0x00600000) == 0x00400000;
}

void tree(const string& filename)
{
   string::size_type pos = filename.find(".dat");
   if(pos == string::npos) {
        cerr << filename << " is not a dat file" << endl;
        return;
   }
   string rootfile_name(filename);
   rootfile_name.replace(pos, 10, ".root");

   // set tree
   TFile *f = new TFile(rootfile_name.c_str(), "RECREATE");
   int evtn=0;
   int chan[64];
   int lowADC[64];
   int highADC[64];
   int tdcLeading[64];
   int tdcTrailing[64];
   int scaler[64];
   float nrate[64];
   for(int ich=0;ich<64;ich++){
       chan[ich]=ich;
       highADC[ich]=-1;
       lowADC[ich]=-1;
       tdcLeading[ich]=-1;
       tdcTrailing[ich]=-1;
       scaler[ich]=-1;
   }

   TTree * tree = new TTree("tree","tree");
   tree->Branch("evtn",&evtn,"evtn/I");
   tree->Branch("chan",chan,"chan[64]/I");
   tree->Branch("lowADC",lowADC,"lowADC[64]/I");
   tree->Branch("highADC",highADC,"highADC[64]/I");
   tree->Branch("tdcLeading",tdcLeading,"tdcLeading[64]/I");
   tree->Branch("tdcTrailing",tdcTrailing,"tdcTrailing[64]/I");
   tree->Branch("scaler",scaler,"scaler[64]/I");

   TTree * rate = new TTree("rate","rate");
   rate->Branch("chan",chan,"chan[64]/I");
   rate->Branch("nrate",nrate,"nrate[64]/F");

   // datat file
   ifstream datFile(filename.c_str(), ios::in | ios::binary);

   const int nAve = 10; // summation for taking avarage of scaler 
   unsigned int scalerValuesArray[nAve][69];
   unsigned int events = 0;

   while ( datFile ) {
       char headerByte[4];  
       datFile.read(headerByte, 4);
       unsigned int header = getBigEndian32(headerByte);
	   //std::cerr << std::hex << header << std::endl;
	   //std::cerr << std::bitset<32>(header) << std::endl;
       bool isHeader = ((header >> 27) & 0x01) == 0x01;

       if (!isHeader) {
       	 std::cerr << "Frame Error" << std::endl;
         fprintf(stderr, "    %08X\n", header);
         std::exit(1);
      }
      size_t dataSize = header & 0x0fff;

      unsigned int scalerValues[69];
      char* dataBytes = new char[dataSize * 4];
      datFile.read(dataBytes, dataSize * 4);

      for (size_t i = 0; i < dataSize; ++i) {
      	unsigned int data = getBigEndian32(dataBytes + 4 * i);

         if (isAdcHg(data)) {
         	int ch = (data >> 13) & 0x3f;
            bool otr = ((data >> 12) & 0x01) != 0;
            int value = data & 0x0fff;
            if(!otr) {
            	highADC[ch]=value;
            }

         } else if (isAdcLg(data)) {
            int ch = (data >> 13) & 0x3f;
            bool otr = ((data >> 12) & 0x01) != 0;
            int value = data & 0x0fff;
            if(!otr) {
                lowADC[ch]=value;
            }

         } else if (isTdcLeading(data)) {
            int ch = (data >> 13) & 0x3f;
            int value = data & 0x0fff;
            tdcLeading[ch]=value;

         } else if (isTdcTrailing(data)) {
            int ch = (data >> 13) & 0x3f;
            int value = data & 0x0fff;
            tdcTrailing[ch]=value;

         } else if (isScaler(data)) {
            int ch = (data >> 14) & 0x7f;
            int value = data & 0x3fff;
            scalerValues[ch] = value;

			scaler[ch] = value;	
#if 1
         	if ( ch==68 ) {
               cerr << " 1K " << scalerValues[68] 
                    << " 1M " << scalerValues[67] << endl;
               // 100 is this correct???? because scalerValuesArray is [10][xx]  
               //int scalerValsArrayIndex = events % 100; 
               int scalerValsArrayIndex = events % nAve; 
               memcpy(scalerValuesArray[scalerValsArrayIndex], 
					scalerValues,
         	        sizeof(scalerValues));
         	}
#else
            if(ch == 68) {
            	int counterCount1MHz = scalerValues[67] & 0x1fff;
               int counterCount1KHz = scalerValues[68] & 0x1fff;

               // 1count = 1.0ms
               double counterCount = (double)counterCount1KHz + counterCount1MHz / 1000.0;
               // TODO
               // Firmwareのバグを直したら消す
               counterCount *= 2.0;
               //cout << "counterCount: " << counterCount << endl;
               for (size_t j = 0; j < 67; ++j) {
                 	bool ovf = ((scalerValues[j] >> 13) & 0x01) != 0;
                  ovf = false;
                  double scalerCount = scalerValues[j] & 0x1fff;
                  //cout << "scalerCount: " << j << " " << scalerCount << endl;
                  if(!ovf && scalerCount != 0) {
                  	double rate = scalerCount / counterCount; // kHz
                     //cout << "rate: " << rate << endl;
                     scaler[j]=rate;
                  }
             	}
              	//cout << endl;
               //cout << endl;
         	}
#endif
       	} else {
         	int ch = (data >> 13) & 0x3f;
            int value = data & 0x0fff;
			std::cout << "adchg:"  << (data & 0x00680000);
			std::cout << "adclg:"  << (data & 0x00680000);
			std::cout << "tdcl:"   << (data & 0x00601000);
			std::cout << "tdct:"   << (data & 0x00601000);
			std::cout << "scaler:" << (data & 0x00600000);
			std::cout << "data:" << data << std::endl; 
			std::cout << "ch:" << ch << " value:" << value << std::endl;
            std::cerr << "Unknown data type" << std::endl;
      	}
   }

   // fill event data
   evtn = events;
   tree->Fill();

    // in every events you calculate noise/counter rate    
	if ( events%nAve == 0 ) {
    	 unsigned int scalerValuesSum[69]={};
         for (int i = 0; i < 69; ++i) {
         	scalerValuesSum[i] = 0;
         }
         for(int i = 0; i < nAve; ++i) {
			for (int j = 0; j < 69; ++j) {
            	scalerValuesSum[j] += scalerValuesArray[i][j];
            }
         }

         int counter1MHz = scalerValuesSum[67];
         int counter1KHz = scalerValuesSum[68];
         cerr << "counter1KHz : " << counter1KHz << endl;
         cerr << "counter1MHz : " << counter1MHz << endl;
         cerr << "counter1MHz - counter1KHz*1000 = " 
              << counter1MHz - counter1KHz*1000 << endl;

         double counterTime = //(double)counter1KHz; /*1 msec*/ 
                              (double)counter1MHz /*1 usec*/ / 1000.0; // ->  msec
         counterTime = counterTime / 1000.0 ; // -> sec

         //cout << "counterTime (sec) " << counterTime << endl;
         // TODO
         // Firmwareのバグを直したら消す
         //       for which reason ?? clock is not correctly counted (ogawa 19/11/10)
         //     temporary, put *= 2.0 since trigger rate ~150Hz w/ the condition that
         //     OneCh_32 && 
         //counterTime /= 2.0;
         //counterTime *= 2.0;
         cout << "counterTime (sec) " << counterTime << endl;

        for(size_t j = 0; j < 67; ++j) {
            //cout << j << " scalerValuesSun: " << scalerValuesSum[j] << ", ";
            bool ovf = ((scalerValuesSum[j] >> 13) & 0x01) != 0;
            
            //   why this was always set to true? (ogawa 19/11/10)
            //   temporary, remove it
            //ovf = true; 
            
            //double scalerCount = scalerValuesSum[j] & 0x1fff;  //changed by N.CHIKUMA 2015 Oct 6
            double scalerCount = scalerValuesSum[j] & 0xffff;
            //cerr << "ch=" << j << " " << "scaler: " << scalerCount << ", ";
            
            if(!ovf && scalerCount != 0) {
               double countrate = scalerCount / counterTime;
               cout << "ch=" << j << " " << "scaler: " << scalerCount << ", " << "channel rate: " << countrate << endl;
               nrate[j]=countrate;
            }
		}

	rate->Fill();
  	}



	// initialize
	for (int ich=0; ich<64; ich++) {
        chan[ich]=ich;
        highADC[ich]=-1;
        lowADC[ich]=-1;
        tdcLeading[ich]=-1;
        tdcTrailing[ich]=-1;
        scaler[ich]=-1;
        nrate[ich]=-1;
	}

	delete[] dataBytes;
	events++;

    if ( events%1000 == 0 )
    	std::cout << "reading events#:" << events << std::endl;

 	} // end of data roop

	f->Write();
	f->Close();
}


int main(int argc, char** argv)
{
    if(argc != 2) {
        cerr << "hist <dat file>" << endl;
        return -1;
    }
    tree(argv[1]);
    return 0;
}
