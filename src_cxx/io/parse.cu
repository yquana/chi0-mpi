#include <iostream>
#include <fstream>
#include <ios>
#include <string>
#include <memory>
#include <sstream>


#include "defs.h"
#include "parse.h"


void parse::parse_input(std::unique_ptr<dataDefs::input> & params_in)
{
	std::ifstream myfile;
	myfile.open("chi0.in", std::ios::in);
	std::string line, tmp[3];
	std::stringstream line_ss;
	while(std::getline(myfile, line))
	{
		line_ss = std::stringstream(line);
		if(line_ss >> tmp[0] >> tmp[1] >> tmp[2])
		{
			std::cout << tmp[0] << " " << tmp[1] << " " << tmp[2] << std::endl;
		}
	}
}

void parse::parse_ek(std::unique_ptr<dataDefs::input> & params_in)
{
	std::ifstream myfile;
	myfile.open(params_in->ek_dat, std::ios::in);
	std::string line, tmp[5];
	std::stringstream line_ss;
	while(std::getline(myfile, line))
	{
		if(line.find_first_not_of(" ") != std::string::npos)
		{
		  line_ss = std::stringstream(line);
		  line_ss >> tmp[0] >> tmp[1] >> tmp[2];
		}
	}
}

void parse::parse_wq(std::unique_ptr<dataDefs::input> & params_in)
{
	std::ifstream myfile;
	std::string line, tmp[5];
	std::stringstream line_ss;
	while(std::getline(myfile, line))
	{
		if(line.find_first_not_of(" ") != std::string::npos)
		{
			line_ss = std::stringstream(line);

		}
	}
}

void parse::parse_g(std::unique_ptr<dataDefs::input> & params_in)
{

}

void parse::parse_wann(std::unique_ptr<dataDefs::input> & params_in)
{

}
