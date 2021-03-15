library flutter_data;

// import external packages
import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:inflection2/inflection2.dart' as inflection;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path_helper;
import 'package:collection/collection.dart';

// import internal packages
import 'src/graph/notifier_extension.dart';
import 'src/repository/hive_local_storage.dart';
import 'src/utils/data_state.dart';

// export external packages
export 'package:riverpod/riverpod.dart' hide Family, Listener;

// export internal packages
export 'src/graph/notifier_extension.dart';
export 'src/repository/hive_local_storage.dart';
export 'src/utils/data_state.dart';

// include parts
part 'src/model/data_model.dart';
part 'src/model/relationship/relationship.dart';
part 'src/model/relationship/has_many.dart';
part 'src/model/relationship/belongs_to.dart';

part 'src/repository/remote_adapter.dart';
part 'src/repository/remote_adapter_serialization.dart';
part 'src/repository/remote_adapter_watch.dart';
part 'src/repository/repository.dart';
part 'src/repository/hive_local_adapter.dart';
part 'src/repository/local_adapter.dart';

part 'src/utils/extensions.dart';
part 'src/utils/framework.dart';
part 'src/utils/initialization.dart';
part 'src/graph/graph_notifier.dart';
