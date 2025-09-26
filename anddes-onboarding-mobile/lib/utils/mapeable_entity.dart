abstract class MapeableEntity {
  Map<String, dynamic> toTableMap();
  int getId();
}

abstract class MapeableEntityWithParentId {
  Map<String, dynamic> toTableMap(int parentId);
  int getId();
}
