#pragma once

#include <fstream>
#include <ios>
#include <string>
#include <memory>


#include "defs.h"


namespace parse
{
    void parse_input(std::unique_ptr<dataDefs::input> & params_in);
}
