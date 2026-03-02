#ifndef WORD_FINDER_HPP
#define WORD_FINDER_HPP

#include <QObject>
#include <QQmlEngine>
#include "source/file_parser.h"

struct Constraints{
    std::string correct;
    std::string good;
    std::string absent;
};

class WordFinder : public QObject {

    Q_OBJECT
    QML_ELEMENT

public:

    explicit WordFinder(QObject* parent = nullptr);

    [[nodiscard]] WordList final_list(const Constraints& constraints) const;

    Q_INVOKABLE void reloadWords(const std::string& path);

private:
    WordList word_list;
};

#endif //WORD_FINDER_HPP
