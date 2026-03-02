#include "source/wordle_backend.h"

WordleBackend::WordleBackend(QObject* parent)
    : QObject(parent)
{}

void WordleBackend::updateConstraints(const QString& correct,
                                      const QString& good,
                                      const QString& absent)
{
    Constraints c;
    c.correct = correct.toStdString();
    c.good = good.toStdString();
    c.absent = absent.toStdString();

    auto result = m_finder.final_list(c);

    m_possibleWords.clear();
    for(const auto& word : result)
    {
        m_possibleWords << QString::fromStdString(word);
    }

    emit possibleWordsChanged();
}

// New Q_INVOKABLE for language switching
void WordleBackend::switchLanguage(const QString& path)
{
    m_finder.reloadWords(path.toStdString());

    // optional: clear the list immediately
    m_possibleWords.clear();
    emit possibleWordsChanged();
}


QStringList WordleBackend::possibleWords() const
{
    return m_possibleWords;
}
