//===--- TypeDiscovery.h - Dynamic type lookup at runtime--------*- C++ -*-===//
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
//
// Functions to look up types in the Swift type system at runtime.
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_RUNTIME_TYPE_DISCOVERY_H
#define SWIFT_RUNTIME_TYPE_DISCOVERY_H

#include "swift/Runtime/Config.h"
#include "swift/Runtime/Error.h"
#include "swift/Runtime/Metadata.h"

namespace swift {
  /// The closure type used by \c swift_enumerateConformingTypesFromImage().
  typedef void (* TypeEnumerationFunction)(
    const Metadata *type,
    bool *stop,
    SWIFT_CONTEXT void *context,
    SWIFT_ERROR_RESULT SwiftError **error) SWIFT_CC(swift);

  /// Enumerate a list of all types (as Metadata) in a given image that conform
  /// to the specified Swift protocol.
  ///
  /// \param imageAddress A platform-specific pointer to the image of interest.
  ///   The image must have been loaded into the current process. Pass
  ///   \c nullptr to search all loaded images.
  /// \param protocolMetadata The protocol of interest. This protocol does not
  ///   need to be declared in the image referenced by \a imageAddress.
  /// \param body A closure to invoke once per matching type.
  /// \param bodyContext The Swift context pointer for \a body.
  /// \param context The Swift context pointer for this function. Ignored.
  /// \param error An error pointer passed to \a body. If \a body throws an
  /// 	error, enumeration is stopped and the error is rethrown.
  ///
  /// This function walks all known types in the given image and checks each for
  /// conformance to \a protocol. Any types that do conform are passed to
  /// \c body for evaluation.
  ///
  /// \bug Generic types with constrained conformance to \a protocol are not
  ///   supported.
  ///
  /// \bug Objective-C protocol conformance lookups are not supported.
  SWIFT_CC(swift) SWIFT_RUNTIME_STDLIB_INTERNAL
  void swift_enumerateConformingTypesFromImage(
    const void *imageAddress,
    const Metadata *protocolMetadata,
    TypeEnumerationFunction body,
    void *bodyContext,
    SWIFT_CONTEXT void *context,
    SWIFT_ERROR_RESULT SwiftError **error);
} // end namespace swift

#endif /* SWIFT_RUNTIME_TYPE_DISCOVERY_H */
