import 'package:protobuf_dart_poc/services/user_service.dart';
import 'package:protobuf_dart_poc/user/user_proto_mapper.dart';

/// This file is the entry point for the protobuf_dart_poc application.
/// 
/// To use this application, you need to have protobuf installed. You can install it using Homebrew by running the following command:
/// 
/// ```
/// brew install protobuf
/// ```
/// 
/// After installing protobuf, you can generate Dart code from your protobuf files using the `protoc` command. For example, to generate Dart code from the `user.proto` file located in the `lib/proto` directory, you can run the following command:
/// 
/// ```
/// protoc --dart_out=lib/generated lib/proto/user.proto
/// ```
/// 
/// This will generate the Dart code in the `lib/generated` directory, which you can then use in your application.
/// 

void main() {
  final userMapper = UserProtoMapper();
  final userService = UserService(userMapper);

  final user = userService.getUser('1');
  print(user.name);
}

/// # Advantages of Using Protobuf
///
/// ## 1. Serialization Efficiency
///
/// - **Compactness**: Protobuf is highly efficient in terms of data compactness.
///   Serialized data in Protobuf format is generally much smaller than JSON or XML,
///   reducing bandwidth usage and transfer times.
/// - **Speed**: Protobuf is faster to serialize and deserialize compared to formats like JSON and XML.
///   This can be crucial in systems where performance is critical.
///
/// ## 2. Strong Typing
///
/// - **Type Safety**: Protobuf offers strong type safety, ensuring that transmitted and received data
///   is always in the expected format. This reduces the risk of type errors that can occur with JSON.
/// - **Schema Evolution**: Protobuf supports schema evolution, allowing you to add new fields to your `.proto`
///   files without breaking compatibility with older versions.
///
/// ## 3. Automatic Code Generation
///
/// - **Consistency**: Protobuf automatically generates classes in various languages from the `.proto` file.
///   This ensures consistency across services and platforms in how serialization and deserialization logic is handled.
///
/// ## 4. Cross-Language Compatibility
///
/// - Protobuf is compatible with many programming languages.
///   If you're working in an environment with multiple languages (e.g., a Go backend and a Dart client),
///   Protobuf facilitates interoperability.
///
/// # Considerations for Your Example
///
/// ## 1. Additional Complexity
///
/// - **Key Mapping**: As you've encountered, using Protobuf can add complexity when JSON keys need to be
///   mapped to field numbers. This can be seen as an overhead, especially if your system is already working well with JSON.
/// - **Integration**: If your system or most of your applications already use JSON,
///   introducing Protobuf might be unnecessary overhead unless you require the performance or type safety advantages.
///
/// ## 2. Suitability for the Use Case
///
/// - **Small vs. Large Projects**: In small projects or where data exchange is simple and low-volume,
///   JSON might be more suitable due to its simplicity and ubiquity.
///   Protobuf shines in more complex or distributed systems where efficiency and scalability are essential.
/// - **Need for Schema Evolution**: If your system requires that data can evolve over time (e.g., adding new fields without breaking older clients),
///   Protobuf provides direct support for this, while JSON might require more manual solutions.
///
/// ## 3. Ecosystem
///
/// - **Tools and Libraries**: Protobuf has a robust ecosystem with support for various tools, but the support and libraries can vary between languages.
///   In Dart, for example, you may need to deal with specific quirks, like the key conversion issue mentioned.
///
/// # When to Use Protobuf
///
/// - **High Data Volume**: When the volume of data being transmitted is large, and the efficiency of compactness and speed is important.
/// - **Interoperability Between Systems**: When different systems, written in different languages, need to share data efficiently and consistently.
/// - **API Evolution**: If your API needs to evolve over time without breaking compatibility with older clients, Protobuf provides good support for this.
///
/// # When It May Not Be Necessary
///
/// - **Simple Projects**: In simple projects or where JSON is widely accepted and the additional overhead of Protobuf is not justified.
/// - **Focus on Ease of Use**: When the readability and ease of manipulation of JSON data are more important than compactness.
///
/// # Conclusion
///
/// The main advantage of using Protobuf in the example you followed is the efficiency and robustness it offers
/// in terms of data serialization, strong typing, and schema evolution. However, this advantage comes with additional complexity,
/// especially in cases where JSON is already widely used and acceptable. The decision to use Protobuf should be based on an analysis
/// of the specific needs of your project in terms of performance, scalability, and compatibility.
