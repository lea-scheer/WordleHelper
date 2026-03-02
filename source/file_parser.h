#ifndef FILEPARSER_HPP
#define FILEPARSER_HPP

#include <vector>
#include <string>
#include <iostream>

using WordList = std::vector<std::string>;

class FileParser {

public:
    [[nodiscard]] WordList get_words_from(const std::string& path) const;
};

std::ostream& operator<<(std::ostream& os, const WordList& word_list);

#endif //FILEPARSER_HPP
