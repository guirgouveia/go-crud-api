# Introduction
This sample forked from famcost was used to implemment the CRUD API with MySQL, using packages such as `net/http`, `database/sql`, `strconv`, 
`html/template` and use a third party packge https://github.com/mattn/go-sqlite3, or an external MySQL Database.

# Basic usage
`docker run --publish 8898:3333 --name famcost --rm thanhngvpt/famcost`


# Advance usage
- Setup environment official here https://golang.org/doc/install
- Create table `
CREATE TABLE cost
(
    id INTEGER PRIMARY KEY NOT NULL,
    electric_amount INTEGER,
    electric_price INTEGER,
    water_amount INTEGER,
    water_price INTEGER,
    checked_date TEXT
);
`
- Run local `go run *.go`
- Docker build `docker build -t famcost .`
- Docker run `docker run --publish 8898:3333 --name famcost --rm famcost`