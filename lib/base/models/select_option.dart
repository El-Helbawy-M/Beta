class SelectOption {
  final dynamic value;
  final String label;
  final int? id;
  bool isSelected = false;
  SelectOption(this.value, this.label, {this.isSelected = false, this.id});
}
