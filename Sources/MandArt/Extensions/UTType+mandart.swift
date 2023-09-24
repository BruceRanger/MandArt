import UniformTypeIdentifiers

/**
 Extend UTType to include org.bhj.mandart (.mandart) files.
 */
@available(macOS 11.0, *)
extension UTType {
  static let mandartDocType = UTType(importedAs: "org.bhj.mandart")
}
