#ifndef WORKOUTMODEL_H
#define WORKOUTMODEL_H

#include <QAbstractListModel>

#include <QAbstractListModel>
#include <QObject>
#include <QList>
#include <QDate>

struct WorkoutItem{
    QString name;
    QString imagePath;
    double weight;
    int sets;
    int reps;
    QString lastDate;
};

class WorkoutModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles{
        NameRole = Qt::UserRole + 1,
        ImageRole,
        WeightRole,
        SetsRole,
        RepsRole,
        DateRole
    };

    explicit WorkoutModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void addMachine(const QString &name, const QString &imagePath, double weight, int sets, int reps);
    Q_INVOKABLE void removeMachine(int index);
    Q_INVOKABLE void editMachine(int index, const QString &name, const QString &imagePath, double weight, int sets, int reps);

private:
    QList<WorkoutItem> m_items;
    QString m_jsonPath;

    void loadData();
    void saveData();
};

#endif // WORKOUTMODEL_H
