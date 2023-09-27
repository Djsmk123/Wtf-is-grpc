dart_proto:
	if not exist flutter_app\lib\pb mkdir flutter_app\lib\pb
	protoc --proto_path=proto --dart_out=grpc:flutter_app/lib/pb proto/*.proto
go_proto:
	if not exist grpc-server\pb mkdir grpc-server\pb
	protoc --proto_path=proto --go_out=grpc-server/pb --go_opt=paths=source_relative \
    --go-grpc_out=grpc-server/pb --go-grpc_opt=paths=source_relative \
    proto/*.proto
evans:
	evans --host localhost --port 9090 -r repl

phony:
	dart_proto go_proto evans