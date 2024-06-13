// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final allocationProvider =
//     StateNotifierProvider<AllocationNotifier, Set<String>>((ref) {
//   return AllocationNotifier();
// });

// class AllocationNotifier extends StateNotifier<Set<String>> {
//   AllocationNotifier() : super({});

//   void allocate(String member) {
//     state = {...state, member};
//   }

//   void deallocate(String member) {
//     state = state..remove(member);
//   }

//   bool isAllocated(String member) {
//     return state.contains(member);
//   }
// }
