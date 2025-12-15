#include "workoutmodel.h"
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

WorkoutModel::WorkoutModel(QObject *parent)
    :QAbstractListModel(parent)
{

    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    m_jsonPath = dataPath + "/workout_data.json";

    QDir dir(dataPath);
    if(!dir.exists()) dir.mkpath(".");

    loadData();
}

int WorkoutModel::rowCount(const QModelIndex &parent) const
{
    if(parent.isValid() ) return 0;

    return m_items.count();
}

QVariant WorkoutModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || index.row() >= m_items.count()) return QVariant();

    const WorkoutItem &item = m_items[index.row()];

    switch( role){
        case NameRole: return item.name;
        case ImageRole: return item.imagePath;
        case WeightRole: return item.weight;
        case SetsRole: return item.sets;
        case RepsRole: return item.reps;
        case DateRole: return item.lastDate;
        default: return QVariant();
    }
}

QHash<int, QByteArray> WorkoutModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ImageRole] = "imagePath";
    roles[WeightRole] = "weight";
    roles[SetsRole] = "sets";
    roles[RepsRole] = "reps";
    roles[DateRole] = "lastDate";
    return roles;
}

void WorkoutModel::addMachine(const QString &name, const QString &imagePath, double weight, int sets, int reps)
{
    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());

    WorkoutItem item;
    item.name = name;
    item.imagePath = imagePath;
    item.weight = weight;
    item.sets = sets;
    item.reps = reps;
    item.lastDate = QDate::currentDate().toString("yyy-MM-dd");

    m_items.append(item);
    endInsertRows();
    saveData();
}

void WorkoutModel::removeMachine(int index)
{
    if(index < 0 || index >= m_items.count()) return;

    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
    saveData();
}

void WorkoutModel::editMachine(int index, const QString &name, const QString &imagePath, double weight, int sets, int reps)
{
    if(index < 0 || index >= m_items.count()) return;

    // 2. Modify the data in place using a reference (&)
    WorkoutItem &item = m_items[index];

    item.name = name;
    // Only update image if a valid path is passed (or handle logic as you prefer)
    item.imagePath = imagePath;
    item.weight = weight;
    item.sets = sets;
    item.reps = reps;
    item.lastDate = QDate::currentDate().toString("yyyy-MM-dd");

    // 3. Create a QModelIndex that points to the row that changed
    // createIndex(row, column) -> We only have 1 column (0)
    QModelIndex modelIndex = createIndex(index, 0);

    // 4. Emit the signal to tell QML to refresh ONLY this row
    // The two arguments are "topLeft" and "bottomRight" of the change area.
    // Since it's just one row, they are the same index.
    emit dataChanged(modelIndex, modelIndex);

    saveData();
}


void WorkoutModel::saveData()
{
    QJsonArray array;
    for(const auto &item: m_items){
        QJsonObject obj;
        obj["name"] = item.name;
        obj["imagePath"] = item.imagePath;
        obj["weight"] = item.weight;
        obj["sets"] = item.sets;
        obj["reps"] = item.reps;
        obj["lastDate"] = item.lastDate;
        array.append(obj);
    }

    QJsonDocument doc(array);
    QFile file(m_jsonPath);
    if(file.open(QIODevice::WriteOnly)){
        file.write(doc.toJson());
        file.close();
    }
}

void WorkoutModel::loadData(){

    QFile file(m_jsonPath);
    if(!file.open(QIODevice::ReadOnly)) return;

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray array = doc.array();

    m_items.clear();
    for(const auto &val : array){
        QJsonObject obj = val.toObject();
        WorkoutItem item;
        item.name = obj["name"].toString();
        item.imagePath = obj["imagePath"].toString();
        item.weight = obj["weight"].toDouble();
        item.sets = obj["sets"].toInt();
        item.reps = obj["reps"].toInt();
        item.lastDate = obj["lastDate"].toString();
        m_items.append(item);
    }

}









