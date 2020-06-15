part of flutter_data;

abstract class DataSupportMixin<T extends DataSupportMixin<T>> {
  Object get id;
  final Map<String, dynamic> _flutterDataMetadata = {};
}

String keyFor<T extends DataSupportMixin<T>>(T model) =>
    model?._flutterDataMetadata['_key'] as String;

// ignore_for_file: unused_element
extension DataSupportMixinExtension<T extends DataSupportMixin<T>>
    on DataSupportMixin<T> {
  T init(Repository<T> repository, {String key, bool save = true}) {
    return repository?.initModel(_this, key: key, save: save);
  }

  Repository<T> get _repository =>
      _flutterDataMetadata['_repository'] as Repository<T>;
  set _repository(Repository<T> value) =>
      _flutterDataMetadata['_repository'] ??= value;

  set _key(String key) {
    _flutterDataMetadata['_key'] = key;
  }

  //

  DataManager get _manager => _repository?.manager;

  T get _this => this as T;

  Future<T> save(
      {bool remote,
      Map<String, dynamic> params,
      Map<String, String> headers}) async {
    _assertRepository();
    return await _repository.save(_this,
        remote: remote, params: params, headers: headers);
  }

  Future<void> delete(
      {bool remote,
      Map<String, dynamic> params,
      Map<String, String> headers}) async {
    _assertRepository();
    await _repository.delete(_this,
        remote: remote, params: params, headers: headers);
  }

  Future<T> reload(
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    _assertRepository();
    return _repository.findOne(_this,
        remote: remote, params: params, headers: headers);
  }

  DataStateNotifier<T> watch(
      {bool remote,
      Map<String, dynamic> params,
      Map<String, String> headers,
      AlsoWatch<T> alsoWatch}) {
    _assertRepository();
    return _repository.watchOne(_this,
        remote: remote, params: params, headers: headers, alsoWatch: alsoWatch);
  }

  bool get isNew => _this.id == null;

  void _assertRepository() {
    assert(
      _repository != null,
      '''\n
Tried to call a method on $this (of type $T), but it is not initialized.

This app has been configured with autoModelInit: false at boot,
which means that model initialization is managed by you.

If you wish Flutter Data to auto-initialize your models,
ensure you configure it at boot:

FlutterData.init(autoModelInit: true);

or simply

FlutterData.init();
''',
    );
  }
}

// auto

abstract class DataSupport<T extends DataSupport<T>> with DataSupportMixin<T> {
  DataSupport() {
    if (_autoModelInitDataManager._autoInitEnabled) {
      _autoModelInitDataManager
          .locator<Repository<T>>()
          ?.initModel(_this, save: true);
    }
  }
}
