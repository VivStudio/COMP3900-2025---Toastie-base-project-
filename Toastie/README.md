# Toastie

# Run frontend

Install dart extension and click run

# Run backend

Install java code runner and click run (on main method)

Run 'mvn install' (mvn clean && install) -- important since it will regen your BE protos (which is being gitignored)

# Regenerate protos

```
Install protoc
$ dart pub global activate protoc_plugin
$ export PATH="$PATH:$HOME/.pub-cache/bin"
```

<!-- Issues with dart generations for protos that have other protos as import, change imports to not have the first protos directory for the following command to work -->

protoc --dart_out=grpc:toastie/lib/protos -Iprotos ./protos/user/user_context.proto

protoc --plugin=protoc-gen-grpc-java --java_out=services/src/main/java protos/user/user_service.proto

<!-- The following command works with the new dart imports -->

protoc -Iprotos/ --java_out=services/src/main/java protos/user/user.proto protos/user/user_context.proto protos/user/user_service.proto

<!-- protoc --plugin=protoc-gen-grpc-java=<path-to-grpc-java>/protoc-gen-grpc-java \
  --grpc-java_out=<output-directory> \
  --java_out=<output-directory> \
  your_service.proto -->

<!-- If all else fails -->
https://github.com/joaomlneto/grpc-java-boilerplate/blob/master/service-handler/src/main/java/io/github/joaomlneto/CalculatorServiceHandler.java


TODOs:
[] On the client side, Create client and channel for all service
[] 