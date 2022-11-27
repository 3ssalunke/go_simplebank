package main

import (
	"database/sql"
	"log"

	api "go-simple_bank/api"
	db "go-simple_bank/db/sqlc"
	"go-simple_bank/util"

	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load configs: ", err)
	}
	dbConn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to database: ", err)
	}
	store := db.NewStore(dbConn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatal("cannot create server: ", err)
	}
	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server: ", err)
	}
}
