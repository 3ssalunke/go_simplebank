postgres:
	docker run --name postgres14 -p 5432\:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=12345secret -d postgres\:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose up

migrateup1:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose up 1

migratedown:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose down

migratedown1:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

proto:
	rm -f pb/*.pb
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
    proto/*.proto

mock:
	mockgen -package mockdb -destination db/mock/store.go go-simple_bank/db/sqlc Store

evans:
	evans --host localhost --port 8080 -r repl

.PHONY: postgres createdb migrateup migratedown sqlc test server mock migrateup1 migratedown1 proto evans
