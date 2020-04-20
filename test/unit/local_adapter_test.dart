import 'package:flutter_data/flutter_data.dart';
import 'package:test/test.dart';

import 'models/family.dart';
import 'models/house.dart';
import 'models/person.dart';
import 'setup.dart';

void main() async {
  setUpAll(setUpAllFn);
  tearDownAll(tearDownAllFn);

  test('serialize', () {
    var manager = injection.locator<DataManager>();

    var person = Person(id: '1', name: 'Franco', age: 28);
    var personRel = HasMany<Person>([person], manager);
    var house = House(id: '1', address: '123 Main St');
    var houseRel = BelongsTo<House>(house, manager);

    var family =
        Family(id: '1', surname: 'Smith', house: houseRel, persons: personRel);

    var map = injection.locator<LocalAdapter<Family>>().serialize(family);
    expect(map, {
      'id': '1',
      'surname': 'Smith',
      'house': houseRel.key,
      'persons': personRel.keys,
      'dogs': null
    });
  });

  test('deserialize', () {
    var manager = injection.locator<DataManager>();

    var person = Person(id: '1', name: 'Franco', age: 28);
    var personRel = HasMany<Person>([person], manager);
    var house = House(id: '1', address: '123 Main St');
    var houseRel = BelongsTo<House>(house, manager);

    var map = {
      'id': '1',
      'surname': 'Smith',
      'house': houseRel.key,
      'persons': personRel.keys
    };

    var family = injection.locator<LocalAdapter<Family>>().deserialize(map);
    expect(family,
        Family(id: '1', surname: 'Smith', house: houseRel, persons: personRel));
  });

  test('typeId', () {
    expect(injection.locator<LocalAdapter<Family>>().typeId, isNotNull);
  });

  test('findAll', () {
    var adapter = injection.locator<LocalAdapter<Family>>();
    var family1 = Family(id: '1', surname: 'Smith');
    var family2 = Family(id: '2', surname: 'Jones');

    adapter.save('families#1', family1);
    adapter.save('families#2', family2);
    var families = adapter.findAll();

    expect(() => families.first.isNew, throwsA(isA<AssertionError>()));

    expect(families, [family1, family2]);
  });

  test('findOne', () {
    var adapter = injection.locator<LocalAdapter<Family>>();
    var family1 = Family(id: '1', surname: 'Smith');

    adapter.save('families#1', family1);
    var family = adapter.findOne('families#1');
    expect(() => family.isNew, throwsA(isA<AssertionError>()));
    expect(family, family1);
  });

  test('set owner in relationships', () {
    var adapter = injection.locator<LocalAdapter<Family>>();

    var person = Person(id: '1', name: 'John', age: 37);
    var house = House(id: '31', address: '123 Main St');
    var family = Family(
        id: '1',
        surname: 'Smith',
        house: BelongsTo<House>(house),
        persons: HasMany<Person>([person]));

    // no dataId associated to family or relationships
    expect(family.house.dataId, isNull);
    expect(family.persons.dataIds, isEmpty);

    adapter.setOwnerInRelationships(
        adapter.manager.dataId<Family>('1'), family);

    // relationships are now associated to a dataId
    expect(family.house.dataId, adapter.manager.dataId<House>('31'));
    expect(family.persons.dataIds.first, adapter.manager.dataId<Person>('1'));
  });

  test('save and find', () {
    var adapter = injection.locator<LocalAdapter<Family>>();
    var family = Family(id: '32423', surname: 'Toraine');
    adapter.save('families#999', family);

    expect(() => family.isNew, throwsA(isA<AssertionError>()));

    var family2 = adapter.findOne('families#999');
    expect(() => family2.isNew, throwsA(isA<AssertionError>()));
    expect(family, family2);
  });

  test('delete', () {
    var adapter = injection.locator<LocalAdapter<Family>>();
    var family = Family(id: '111', surname: 'Smith');
    adapter.save('f1', family);
    adapter.delete('f1');
    expect(adapter.findOne('f1'), isNull);
    adapter.delete('f1');
  });

  test('fixMap', () {
    var before = {
      'person': <dynamic, dynamic>{'age': 32}
    };
    var after = injection.locator<LocalAdapter<Person>>().fixMap(before);

    expect(after['person'], isA<Map<String, dynamic>>());
  });
}
