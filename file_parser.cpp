#include "file_parser.h"
#include <iostream>
#include <fstream>
#include <algorithm>

constexpr unsigned int SIZE_WORD = 5;

std::vector<std::string> FileParser::get_words_from(const std::string& path) const
{
    std::ifstream file(path);
    std::string line;
    std::vector<std::string> words;

    while (std::getline(file, line))
    {
        if(line.size() == 5 &&
            std::all_of(line.begin(), line.end(),
                        [](char c){ return c >= 'a' && c <= 'z'; }))
        {
            words.emplace_back(line);
        }
    }
    return words;
}

std::ostream& operator<<(std::ostream& os, const WordList& word_list)
{
    for (auto& word : word_list)
    {
        os << word << std::endl;
    }
    return os;
}
