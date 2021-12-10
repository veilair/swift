//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_silgen_name("swift_enumerateConformingTypesFromImage")
private func _swift_enumerateTypes(
  fromImageAt imageAddress: UnsafeRawPointer?,
  conformingTo protocolType: Any.Type,
  _ body: (_ type: Any.Type, _ stop: inout Bool) throws -> Void
) rethrows

/// Enumerate all types in a given image that conform to the specified Swift
/// protocol.
///
/// - Parameters:
///   - imageAddress: A platform-specific pointer to the image of interest. The
///     image must have been loaded into the current process. For the binary of
///     the calling function, you can pass `#dsohandle`. For all binaries, pass
///     `nil` (the default.)
///   - protocolType: The protocol of interest. This protocol does not need to
///     be declared in the image referenced by `imageAddress`.
///   - body: A closure to invoke once per conforming type.
///
/// - Throws: Whatever is thrown by `body`.
///
/// This function walks all known types in the given image and checks each for
/// conformance to `protocolType`. If the type conforms, it is passed to `body`.
///
/// Only Swift protocol types (for example, `Hashable.self` or
/// `(Hashable & Codable).self`) should be passed to this function. All other
/// types will produce a fatal error at runtime.
///
/// - Bug: Generic types that conform to `protocolType` are not enumerated by
///   this function.
///
/// - Bug: Objective-C protocol conformance lookups are not supported yet.
@available(SwiftStdlib 9999, *)
public func _enumerateTypes(
  fromImageAt imageAddress: UnsafeRawPointer? = nil,
  conformingTo protocolType: Any.Type,
  _ body: (_ type: Any.Type, _ stop: inout Bool) throws -> Void
) rethrows {
  try _swift_enumerateTypes(
    fromImageAt: imageAddress,
    conformingTo: protocolType,
    body
  )
}

