class Item {
  String name;
  double value;
  String? id;

  Item(this.name, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && name == other.name && value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  Item.fromMap(Map<String, dynamic> itemMap, String id)
    : name = itemMap['name'],
      value = itemMap['value'],
      this.id = id;
  
  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "value": value
    };
  }

}