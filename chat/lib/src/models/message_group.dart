class MessageGroup {
  String? get id => _id;
  String? name;
  String? createdBy;
  List<String> members;
  String? _id;

  MessageGroup({
    required this.createdBy,
    required this.name,
    required this.members,
  });

  toJson() => {
        'created_by': this.createdBy,
        'name': this.name,
        'members': this.members,
      };
  factory MessageGroup.fromJson(Map<String, dynamic> json) {
    var group = MessageGroup(
        createdBy: json['created_by'],
        name: json['name'],
        members: List<String>.from(json['members']));
    group._id = json['id'];
    return group;
  }
}
