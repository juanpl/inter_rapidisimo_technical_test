// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_catalog_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductCatalogModel _$ProductCatalogModelFromJson(Map<String, dynamic> json) {
  return _ProductCatalogModel.fromJson(json);
}

/// @nodoc
mixin _$ProductCatalogModel {
  List<ProductModel> get products => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this ProductCatalogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCatalogModelCopyWith<ProductCatalogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCatalogModelCopyWith<$Res> {
  factory $ProductCatalogModelCopyWith(
    ProductCatalogModel value,
    $Res Function(ProductCatalogModel) then,
  ) = _$ProductCatalogModelCopyWithImpl<$Res, ProductCatalogModel>;
  @useResult
  $Res call({List<ProductModel> products, int total, int skip, int limit});
}

/// @nodoc
class _$ProductCatalogModelCopyWithImpl<$Res, $Val extends ProductCatalogModel>
    implements $ProductCatalogModelCopyWith<$Res> {
  _$ProductCatalogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<ProductModel>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            skip: null == skip
                ? _value.skip
                : skip // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductCatalogModelImplCopyWith<$Res>
    implements $ProductCatalogModelCopyWith<$Res> {
  factory _$$ProductCatalogModelImplCopyWith(
    _$ProductCatalogModelImpl value,
    $Res Function(_$ProductCatalogModelImpl) then,
  ) = __$$ProductCatalogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ProductModel> products, int total, int skip, int limit});
}

/// @nodoc
class __$$ProductCatalogModelImplCopyWithImpl<$Res>
    extends _$ProductCatalogModelCopyWithImpl<$Res, _$ProductCatalogModelImpl>
    implements _$$ProductCatalogModelImplCopyWith<$Res> {
  __$$ProductCatalogModelImplCopyWithImpl(
    _$ProductCatalogModelImpl _value,
    $Res Function(_$ProductCatalogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(
      _$ProductCatalogModelImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<ProductModel>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductCatalogModelImpl implements _ProductCatalogModel {
  const _$ProductCatalogModelImpl({
    required final List<ProductModel> products,
    required this.total,
    required this.skip,
    required this.limit,
  }) : _products = products;

  factory _$ProductCatalogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCatalogModelImplFromJson(json);

  final List<ProductModel> _products;
  @override
  List<ProductModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;

  @override
  String toString() {
    return 'ProductCatalogModel(products: $products, total: $total, skip: $skip, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCatalogModelImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    total,
    skip,
    limit,
  );

  /// Create a copy of ProductCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCatalogModelImplCopyWith<_$ProductCatalogModelImpl> get copyWith =>
      __$$ProductCatalogModelImplCopyWithImpl<_$ProductCatalogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCatalogModelImplToJson(this);
  }
}

abstract class _ProductCatalogModel implements ProductCatalogModel {
  const factory _ProductCatalogModel({
    required final List<ProductModel> products,
    required final int total,
    required final int skip,
    required final int limit,
  }) = _$ProductCatalogModelImpl;

  factory _ProductCatalogModel.fromJson(Map<String, dynamic> json) =
      _$ProductCatalogModelImpl.fromJson;

  @override
  List<ProductModel> get products;
  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;

  /// Create a copy of ProductCatalogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductCatalogModelImplCopyWith<_$ProductCatalogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
