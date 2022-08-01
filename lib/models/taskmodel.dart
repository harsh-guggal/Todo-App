class TaskModel {
  String? title;
  String? description;
  String? time;
  DateTime? timestamp;

  TaskModel({this.title, this.description, this.time, this.timestamp});

// receiving data from server/database
  factory TaskModel.fromMap(map) {
    return TaskModel(
      title: map['title'],
      description: map['description'],
      time: map['time'],
      timestamp: map['timestamp'],
    );
  }

// sending data to server/database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'timestamp': timestamp,
    };
  }
}
