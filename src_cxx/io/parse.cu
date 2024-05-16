#include <iostream>
#include <fstream>
#include <ios>
#include <string>
#include <memory>
#include <stringstream>


#include "defs.h"


void parse::parse_input(std::unique_ptr<dataDef::input> & params_in)
{
	std::ifstream myfile;
	myfile.open("chi0.in", std::ios::in);
	std::string line, tmp[3];
	std::stringstream line_ss;
	while(std::gelint(myfile, line))
	{
		line_ss = std::stringstream(line);
		if(line_ss >> tmp[0] >> tmp[1] >> tmp[2])
		{
			std::cout << tmp[0] << " " << tmp[1] << " " << tmp[2] << std::endl;
		}
	}
}
