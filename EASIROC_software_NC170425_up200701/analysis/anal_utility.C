

std::vector <std::pair <double, double>> GetFileVaule3(TString dir ="test")
{
	ifstream ifs[1];
	for (int i=0; i<1; i++) {
		ifs[i].open(dir+"summary.txt");
	}

    std::vector <std::pair <double, double>> ret;

	double a, b, c;
	while ( ifs[0] >> a >> b >> c ) {
		cerr << a << " " << b << endl;
        ret.push_back( std::pair <double, double> (b,c) );
	}
    return ret;
}
