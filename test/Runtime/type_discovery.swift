// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest

protocol P { }
struct A: P { }
class B: P { }
enum C: P { }
struct D /* does not conform */ { }

guard #available(SwiftStdlib 9999, *) else {
  print("Skipping tests in \(#fileID) due to unavailability.")
  return
}

// Don't use #dsohandle on Windows because __ImageBase is not linked properly
// when building the test target and we get a link-time error trying to use it.
let address: UnsafeRawPointer?
#if os(Windows)
address = nil
#else
address = #dsohandle
#endif

do {
  var typeList = [P.Type]()

  _enumerateTypes(fromImageAt: address, conformingTo: P.self) { type, _ in
    typeList.append(type as! P.Type)
  }
  expectTrue(typeList.contains(where: { $0 == A.self }))
  expectTrue(typeList.contains(where: { $0 == B.self }))
  expectTrue(typeList.contains(where: { $0 == C.self }))
  expectFalse(typeList.contains(where: { $0 == D.self }))
}

// Test that `stop` works.
do {
  var iterationCount = 0
  _enumerateTypes(fromImageAt: address, conformingTo: P.self) { type, _ in
    iterationCount += 1
    stop = true
  }
  expectEqual(iterationCount, 1)
}
