import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

enum SkillType {
  @JsonValue('Software')
  software('Software Development'),
  @JsonValue('Systems')
  systems('Systems & Architecture');

  const SkillType(this.label);

  final String label;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Skill {
  const Skill({
    this.id,
    required this.name,
    required this.skillType,
    required this.description,
    this.imageFilename = '',
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String name;
  final SkillType skillType;
  final String description;

  @JsonKey(defaultValue: '')
  final String imageFilename;

  @JsonKey(defaultValue: 0, includeToJson: false)
  final int starCount;

  @JsonKey(defaultValue: false, includeToJson: false)
  final bool isStarred;

  @JsonKey(defaultValue: '', includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
