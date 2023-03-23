// import 'package:animated_scroll_view/src/models/modification.dart';
// import 'package:meta/meta.dart';

// ///
// @sealed
// @immutable
// class IDWithModification {
//   const IDWithModification({required this.id, required this.modification});

//   const IDWithModification.insert({required this.id})
//       : modification = Modification.insert;
//   const IDWithModification.remove({required this.id})
//       : modification = Modification.remove;
//   const IDWithModification.none({required this.id})
//       : modification = Modification.none;

//   String get stringify => modification.interpolate(id);

//   static String getRawIdFromIDWithModification(String idWithModification) {
//     return Modification.removePrefixes(idWithModification);
//   }

//   @protected
//   final String id;

//   @protected
//   final Modification modification;

//   @override
//   String toString() => stringify;

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is IDWithModification &&
//         other.id == id &&
//         other.modification == modification;
//   }

//   @override
//   int get hashCode => id.hashCode ^ modification.hashCode;
// }
