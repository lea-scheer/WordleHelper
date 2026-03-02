#include "wordle_finder.h"
#include "file_parser.h"
#include <algorithm>
#include <unordered_map>
#include <unordered_set>

WordFinder::WordFinder(QObject* parent) : QObject(parent)
{
    // Default English word list
    word_list = FileParser().get_words_from("/home/andrea/SoftPerso/Lea/MyQMLexercice/WordleHelper/words_list.txt");
}

WordList WordFinder::final_list(const Constraints& constraints) const
{
    WordList result;

    std::unordered_map<char,int> required_count;
    for(char c : constraints.correct)
    {
        if(c != '-') required_count[c]++;
    }
    for(char c : constraints.good)
    {
        if(c != '-') required_count[c]++;
    }

    for(const auto& word : word_list)
    {
        bool keep = true;

        // ---- 0) Check word has as many time duplicated letters as in given letters, good or correct
        for(auto [c, count] : required_count)
        {
            auto word_count = std::count(word.begin(), word.end(), c);
            if(word_count < count)
            {
                keep = false;
                break;
            }
        }

        if(!keep) continue;

        // ---- 1) Correct letters (well placed)
        for(size_t i = 0; i < constraints.correct.size(); ++i)
        {
            if(constraints.correct[i] == '-') continue;

            if(word[i] != constraints.correct[i])
            {
                keep = false;
                break;
            }
        }

        if(!keep) continue;

        // ---- 2) Good letters misplaced
        for(size_t i = 0; i < constraints.good.size(); ++i)
        {
            char c = constraints.good[i];

            if(c == '-') continue;

            // must NOT be at same position
            if(word[i] == c)
            {
                keep = false;
                break;
            }

            // must exist somewhere in word
            if(word.find(c) == std::string::npos)
            {
                keep = false;
                break;
            }
        }

        if(!keep) continue;

        // ---- 3) Absent letters
        std::unordered_set<char> absent(constraints.absent.begin(), constraints.absent.end());
        for(char c : word)
        {
            if(absent.count(c))
            {
                keep = false;
            }
        }

        if(keep)
        {
            result.emplace_back(word);
        }
    }

    return result;
}

void WordFinder::reloadWords(const std::string& path)
{
    word_list = FileParser().get_words_from(path);
}
