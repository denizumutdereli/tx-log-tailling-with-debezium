build:
	docker-compose -f ./docker/docker-compose.yml up -d 
start:
	docker start postgres
	docker start zookeeper
	docker start kafka
	docker start kafka_connect_with_debezium
createdb:
	docker exec -it postgres createdb --encoding=UTF8 --username=admin --owner=admin auth
dropdb:
	docker exec -it postgres dropdb auth
migrate_create:
	migrate create -ext sql -dir ./db/migration -seq auth_schemas
migrateup:
	migrate -path db/migration -database "postgresql://admin:secret@127.0.0.1:5432/auth?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://admin:secret@127.0.0.1:5432/auth?sslmode=disable" -verbose down
code:
	sqlc generate
test:
	go test -v -cover ./db/... -timeout 10s
.PHONY: build start createdb dropdb migrate_create migrateup migratedown sqlc test