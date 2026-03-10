#include "source/file_parser.h"
#include <iostream>
#include <QFile>
#include <QTextStream>
#include <algorithm>

constexpr unsigned int SIZE_WORD = 5;

std::vector<std::string> FileParser::get_words_from(const std::string& path) const
{
    QFile file(QString::fromStdString(path));

    WordList words;


    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return words;

    QTextStream in(&file);

    while(!in.atEnd())
    {
        QString line = in.readLine();

        if(line.size() == 5 &&
            std::all_of(line.begin(), line.end(),
                        [](QChar c){ return c >= 'a' && c <= 'z'; }))
        {
            words.emplace_back(line.toStdString());
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
