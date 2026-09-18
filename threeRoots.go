package main
//PACKAGE HAS TO BE MAIN TO COMPILE .EXE FILE
import (
    "database/sql"
    "fmt"
    //"time"
    _ "github.com/go-sql-driver/mysql"
)


//WORKS
//MOVE VARIABLE TO CONFIG FILE
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

//call static methods as 'package.function'

// Object (struct)
// then
// DAL (methods)

type Customer struct{
    id int
    name string
    address string
    city string
    state string
    zip int
    phone string
    email string
}

//CUST DAL
//put init as create function with DAL???

//CUST functions, initializer function
func custInit(newId int, newAddress string, newCity string, newState string, newZip int, newName string,
     newPhone string, newEmail string) *Customer{
    
    var newCust Customer
    newCust.id = newId
    newCust.name = newName
    newCust.address = newAddress
    newCust.city = newCity
    newCust.state = newState
    newCust.zip = newZip
    newCust.phone = newPhone
    newCust.email = newEmail

    return &newCust
}

type Plant struct{
    id int
    species string
}

//PLANT DAL
//put init as create function with DAL???
func plantInit(newId int, newSpecies string) *Plant{
    var newPlant Plant
    newPlant.id = newId
    newPlant.species = newSpecies

    return &newPlant
}

func main(){
    myPlant := plantInit(2, "Hydrangea")
    fmt.Println("Plant ID: ")
    fmt.Println(myPlant.id)
    fmt.Println("Plant Species: ")
    fmt.Println(myPlant.species)
}


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


//CUSTPLANT DAL

type Appointment struct{
    custID int
    //EXPLORE TIME LATER ... string maybe???
    firstVisit bool
}

