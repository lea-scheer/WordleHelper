#include "source/wordle_finder.h"
#include "source/file_parser.h"
#include <algorithm>
#include <unordered_map>
#include <unordered_set>

constexpr unsigned int SIZE_WORD = 5;

WordFinder::WordFinder(QObject* parent) : QObject(parent)
{
    // Default English word list
    word_list = FileParser().get_words_from(":/dictionaries/words_list.txt");
}

WordList WordFinder::final_list(const Constraints& constraints) const
{
    WordList result;

    std::unordered_map<char,int> correct_count;
    std::unordered_map<char,int> good_max_count;

    // 1) count correct letters
    for(char c : constraints.correct)
    {
        if(c != '-')
        {
            correct_count[c]++;
        }
    }

    // 2) max occurrence in good
    for(const auto& row : constraints.goodRows)
    {
        std::unordered_map<char,int> row_count;

        for(char c : row)
        {
            if(c != '-')
            {
                row_count[c]++;
            }
        }

        for(auto [c,count] : row_count)
        {
            good_max_count[c] = std::max(good_max_count[c], count);
        }
    }

    // 3) result
    std::unordered_map<char,int> required_count;

    for(auto [c,count] : correct_count)
    {
        required_count[c] = count + good_max_count[c];
    }

    for(auto [c,count] : good_max_count)
    {
        if(required_count.find(c) == required_count.end())
            required_count[c] = count;
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
        for(const auto& row : constraints.goodRows)
        {
            for (size_t i = 0; i < SIZE_WORD; ++i)
            {
                char c = row[i];

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
