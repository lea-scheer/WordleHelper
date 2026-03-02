/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#include <wordle_backend.h>
#include <wordle_finder.h>

#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif

Q_QMLTYPE_EXPORT void qml_register_types_WordleHelper()
{
    qmlRegisterTypesAndRevisions<WordFinder>("WordleHelper", 1);
    qmlRegisterTypesAndRevisions<WordleBackend>("WordleHelper", 1);
    qmlRegisterModule("WordleHelper", 1, 0);
}

static const QQmlModuleRegistration registration("WordleHelper", qml_register_types_WordleHelper);
