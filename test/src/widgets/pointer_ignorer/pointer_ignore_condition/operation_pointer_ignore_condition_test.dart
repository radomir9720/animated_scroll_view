import 'dart:math';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OperationPointerIgnoreCondition', () {
    group('equality operator', () {
      group('returns true when instances are equal', () {
        const allOperations = [
          Operation.equalsTo,
          Operation.notEqualsTo,
          Operation.greaterThan,
          Operation.greaterOrEqualTo,
          Operation.lessThan,
          Operation.lessOrEqualTo,
        ];
        test('(constructor syntax on both sides)', () {
          for (final operation in allOperations) {
            final randomNumber = Random().nextDouble();
            expect(
              OperationPointerIgnoreCondition(
                    operation: operation,
                    value: randomNumber,
                  ) ==
                  OperationPointerIgnoreCondition(
                    operation: operation,
                    value: randomNumber,
                  ),
              isTrue,
            );
          }
        });

        test(
            '(constructor syntax on one side, num extension getter on another)',
            () {
          for (final operation in allOperations) {
            final randomNumber = Random().nextDouble();
            final index = allOperations.indexOf(operation);
            final shortCutConditions = [
              randomNumber.equalsTo,
              randomNumber.notEqualsTo,
              randomNumber.greaterThan,
              randomNumber.greaterOrEqualTo,
              randomNumber.lessThan,
              randomNumber.lessOrEqualTo,
            ];

            expect(
              OperationPointerIgnoreCondition(
                    operation: operation,
                    value: randomNumber,
                  ) ==
                  shortCutConditions[index],
              isTrue,
            );
          }
        });
      });

      group('returns false when instances are not equal', () {
        test('(values equal, operations not equal)', () {
          final randomNumber = Random().nextDouble();
          expect(
            OperationPointerIgnoreCondition(
                  operation: Operation.equalsTo,
                  value: randomNumber,
                ) ==
                OperationPointerIgnoreCondition(
                  operation: Operation.greaterThan,
                  value: randomNumber,
                ),
            isFalse,
          );
          expect(
            randomNumber.equalsTo == randomNumber.greaterOrEqualTo,
            isFalse,
          );
        });
        test('(values not equal, operations equal)', () {
          expect(
            const OperationPointerIgnoreCondition(
                  operation: Operation.greaterOrEqualTo,
                  value: 4,
                ) ==
                const OperationPointerIgnoreCondition(
                  operation: Operation.greaterOrEqualTo,
                  value: 2.44,
                ),
            isFalse,
          );

          expect(3.greaterThan == 1.greaterThan, isFalse);
        });
        test('(both values and operations not equal)', () {
          expect(
            const OperationPointerIgnoreCondition(
                  operation: Operation.lessThan,
                  value: 44.12,
                ) ==
                const OperationPointerIgnoreCondition(
                  operation: Operation.lessOrEqualTo,
                  value: -123,
                ),
            isFalse,
          );

          expect(432.lessThan == (-232.09).lessOrEqualTo, isFalse);
        });
      });
    });

    group('equalsTo', () {
      test('returns true when values are equal', () {
        // assert
        expect(1.equalsTo.check(1), isTrue);

        expect((-10234).equalsTo.check(-10234), isTrue);

        expect(1.5.equalsTo.check(1.5), isTrue);
      });

      test('returns false when values are not equal', () {
        expect(1.equalsTo.check(-10234), isFalse);

        expect((-10234).equalsTo.check(1), isFalse);

        expect(2.equalsTo.check(1.999999), isFalse);
      });
    });

    group('notEqualsTo', () {
      test('returns true when values are not equal', () {
        expect(1.notEqualsTo.check(-10234), isTrue);

        expect((-10234).notEqualsTo.check(1), isTrue);

        expect(2.notEqualsTo.check(1.999999), isTrue);
      });

      test('reutrns false when values are equal', () {
        expect(1.notEqualsTo.check(1), isFalse);

        expect((-10234).notEqualsTo.check(-10234), isFalse);

        expect(1.5.notEqualsTo.check(1.5), isFalse);
      });
    });

    group('greaterThan', () {
      test(
          'returns true when OperationPointerIgnoreCondition.value is greater '
          'than animationValue', () {
        expect(2.greaterThan.check(1.5), isTrue);

        expect(1.5000001.greaterThan.check(1.5), isTrue);

        expect(1000.greaterThan.check(-1000), isTrue);
      });

      test('returns false when values are equal', () {
        expect(1000.greaterThan.check(1000), isFalse);

        expect(0.greaterThan.check(0), isFalse);

        expect(.333.greaterThan.check(.333), isFalse);
      });
      test(
          'returns false when OperationPointerIgnoreCondition.value is less '
          'than  animationValue', () {
        expect(999.9999.greaterThan.check(1000), isFalse);

        expect((-1000).greaterThan.check(0), isFalse);

        expect(0.greaterThan.check(.333), isFalse);
      });
    });

    group('greaterOrEqualTo', () {
      test(
          'returns true when OperationPointerIgnoreCondition.value is greater '
          'than or equal to  animationValue', () {
        expect(0.greaterOrEqualTo.check(0), isTrue);

        expect(100.00001.greaterOrEqualTo.check(100), isTrue);

        expect(1.greaterOrEqualTo.check(-100), isTrue);
      });

      test(
        'returns false when OperationPointerIgnoreCondition.value is less '
        'than animationValue',
        () {
          expect((-.999).greaterOrEqualTo.check(0), isFalse);

          expect((-1000).greaterOrEqualTo.check(21420), isFalse);

          expect(345.21.greaterOrEqualTo.check(345.22), isFalse);
        },
      );
    });

    group('lessThan', () {
      test(
        'returns true when OperationPointerIgnoreCondition.value is less '
        'than animationValue',
        () {
          expect(0.lessThan.check(123), isTrue);

          expect((-.999).lessThan.check(1), isTrue);

          expect((-1231).lessThan.check(912319), isTrue);
        },
      );
      test(
        'returns false when OperationPointerIgnoreCondition.value '
        'is greater than or equal to animationValue',
        () {
          expect(1.lessThan.check(0), isFalse);

          expect((-.999).lessThan.check(-1), isFalse);

          expect(912319.lessThan.check(912319), isFalse);
        },
      );
    });

    group('lessThanOrEqualTo', () {
      test(
          'returns true when OperationPointerIgnoreCondition.value '
          'is less than or equal to animationValue', () {
        expect(1.lessOrEqualTo.check(1), isTrue);
        expect(0.lessOrEqualTo.check(1), isTrue);
        expect((-.123).lessOrEqualTo.check(-.122), isTrue);
        expect(12312.lessOrEqualTo.check(232312), isTrue);
      });

      test(
          'returns false when OperationPointerIgnoreCondition.value '
          'is greater than animationValue', () {
        expect(2.lessOrEqualTo.check(1), isFalse);
        expect(1.0001.lessOrEqualTo.check(1), isFalse);
        expect((-.123).lessOrEqualTo.check(-.124), isFalse);
      });
    });
  });
}
