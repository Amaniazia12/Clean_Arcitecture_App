import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/utils/convertor.dart';
part 'number_trivia_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NumberTriviaModel extends NumberTrivia {
  @JsonKey(
    fromJson: doubleToInt,
  )
  @override
  int get number;

  NumberTriviaModel({
    required String text,
    required int number,
  }) : super(
          text: text,
          number: number,
        );

  // NumberTriviaModel.fromJson(Map<String, dynamic> json) {

  // }

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return _$NumberTriviaModelFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$NumberTriviaModelToJson(this);
    // return {
    //   "number": number,
    //   "text": text,
    // };
  }
//  @override

//   List<Object?> get props => super.props..add(s);
  // @override
  // List<Object?> get props {

  //   List<Object> a =[];
  //   a.add(2);
  //   return a..add(2)..add(3);
  // }
}
