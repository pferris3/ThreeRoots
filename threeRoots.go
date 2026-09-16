package threeRoots
import (
    "database/sql"
    "fmt"
    _ "github.com/go-sql-driver/mysql"
)


#WORKS
#MOVE VARIABLE TO CONFIG FILE
func connect() {
    dsn := "username:password@tcp(127.0.0.1:3306)/yourdbname"
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        panic(err.Error())
    }
    defer db.Close()
    if err := db.Ping(); err != nil {
        panic(err.Error())
    }
    fmt.Println("Connected to MySQL!")



}

type Plant struct{
    
}

// Object (struct)
// then
// DAL (methods)