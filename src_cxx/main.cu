#include <iostream>
#include <memory>


#include "io/parse.h"
#include "defs.h"

int main(int argc, char * argv[])
{
	std::unique_ptr<dataDefs::input> params_in (new dataDefs::input);
	parse::parse_input(params_in);
}
