#ifndef WORDLE_BACKEND_H
#define WORDLE_BACKEND_H

#include "source/wordle_finder.h"

#include <QObject>
#include <QQmlEngine>

class WordleBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QStringList possibleWords READ possibleWords NOTIFY possibleWordsChanged)

public:
    explicit WordleBackend(QObject* parent = nullptr);

    Q_INVOKABLE void updateConstraints(const QString& correct,
                                       const QString& good,
                                       const QString& absent);

    QStringList possibleWords() const;

    Q_INVOKABLE void switchLanguage(const QString& path);

signals:
    void possibleWordsChanged();

private:
    WordFinder m_finder;
    QStringList m_possibleWords;
};


#endif // WORDLE_BACKEND_H
