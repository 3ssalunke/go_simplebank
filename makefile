postgres:
	docker run --name postgres14 -p 5432\:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=12345secret -d postgres\:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose up

migratedown:
	migrate --path db/migrations --database "postgresql://root:12345secret@localhost:5432/simple_bank?sslmode=disable" --verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./... 

.PHONY: postgres createdb migrateup migratedown sqlc
