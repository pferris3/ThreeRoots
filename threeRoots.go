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

// Object (struct)
// then
// DAL (methods)

type Customer struct{
    id int
    address string
    city string
    state string
    zip int
    name string 
    phone string
    email string
}

//CUST DAL
//put init as create function with DAL???

type Plant struct{
    id int
    species string
}

//PLANT DAL
//put init as create function with DAL???


type CustPlant struct{
    custID int
    plantID int
    quan int
    bug_treat bool
    water_freq_days int
    wetness int
    fertilizer bool
    repotting bool
}


