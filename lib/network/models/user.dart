part of 'model.dart';

@JsonSerializable()
class User extends Equatable {
  String? name;
  String? image;
  @JsonKey(defaultValue: "")
  String? countryCode;
  String? email;
  String? mobile;
  String? country;
  String? city;
  String? state;
  String? pincode;
  String? gender;
  String? useMachine;
  String? designFormat;
  String? designType;

   User({
     this.name,
     this.image,
     this.email,
     this.mobile,
     this.countryCode,
     this.city,
     this.state,
     this.pincode,
     this.country,
     this.gender,
     this.useMachine,
     this.designFormat,
     this.designType,
  });

  factory User.fromJson(Json json) => _$UserFromJson(json);

  Json toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        name,
        image,
        email,
        mobile,
        countryCode,
        country,
        state,
        city,
        pincode,
        gender,
        useMachine,
        designFormat,
        designType,
      ];

  User copyWith({
    String? name,
    String? image,
    String? countryCode,
    String? email,
    String? mobile,
    String? country,
    String? state,
    String? city,
    String? pincode,
    String? gender,
    String? useMachine,
    String? designFormat,
    String? designType,
  }) {
    return User(
      name: name ?? this.name,
      image: image ?? this.image,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      country: country ?? this.country,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      gender: gender ?? this.gender,
      useMachine: useMachine ?? this.useMachine,
      designFormat: designFormat ?? this.designFormat,
      designType: designType ?? this.designType,
    );
  }
}

@JsonSerializable()
class LoginResponse extends User {
  final String token;

   LoginResponse({
    required this.token,
    String? name,
    String? image,
    String? email,
    String? mobile,
    String? countryCode,
    String? country,
    String? state,
    String? city,
    String? pincode,
    String? gender,
    String? useMachine,
    String? designFormat,
    String? designType,
  }) : super(
          name: name,
          image: image,
          email: email,
          mobile: mobile,
          countryCode: countryCode,
          country: country,
          state: state,
          city: city,
          pincode: pincode,
          gender: gender,
          useMachine: useMachine,
          designFormat: designFormat,
          designType: designType,
        );

  @override
  List<Object?> get props => [...super.props, token];

  factory LoginResponse.fromJson(Json json) => _$LoginResponseFromJson(json);

  @override
  Json toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class ImageUploadResponse extends Equatable {
  final String url;

  const ImageUploadResponse({required this.url});

  @override
  List<Object?> get props => [url];

  factory ImageUploadResponse.fromJson(Json json) => _$ImageUploadResponseFromJson(json);

  Json toJson() => _$ImageUploadResponseToJson(this);
}
