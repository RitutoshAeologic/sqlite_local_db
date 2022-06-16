class NotesModel
{
  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  NotesModel({
    this.id,
   required this.email,
    required this.title,
    required this.age,
    required this.description,
});
  NotesModel.fromMap(Map<String, dynamic> res):
        id = res['id'],
        title = res['title'],
        age = res['age'],
        email = res['email'],
        description = res['description'];

  Map<String, Object?> toMap(){
    return {
     'id' : id ,
      'title' : title,
      'age' : age,
      'description' : description,
      'email' : email
    };
  }

}