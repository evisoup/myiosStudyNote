//: Playground - noun: a place where people can play

import UIKit


// split a string wiht
let s1 = "Hello playground"
let s1Result = s1.components(separatedBy: " ")


//modolu, remainder
let d1 = 10.0
let d1Result = d1.truncatingRemainder(dividingBy: 3)


//extract char at 
let s2 = "Hello playground"
var s2Result = s2[s2.index( s2.startIndex, offsetBy: 0) ]
//or
let  s2Result1 = Array(s2.characters)  //<<<<<<<<this
let  s2Result2 = s2Result1[0]


//for loop fancy
for (index, element) in s2Result1.enumerated() {
//    print("Item \(index): \(element)")
}

// arrary of string to string
let a3 = ["a","b","c"]
let a3Result = a3.joined(separator: " ")

//map reduce flatmap
let a4 = [1,2,3,4]
let a4Result1 = a4.map {$0 * 3 }
a4Result1
let a4Result2 = a4.reduce(0) {$0 + $1}  // 0 = initial val or just a4.reduce(0,+)
a4Result2 // = 1 + 2 + 3 + 4

let a5: [[Int]?] = [[1,2], [3], nil, [4,5,6]]
let a6: [[Int]] = [[1,2], [3], [4,5,6]]

let a5Result1 = a5.flatMap { $0 }
a5Result1 //no more nil

let a6Result1 = a6.flatMap {$0}
a6Result1 // flattened

//sub Strings:
let s7 = "Hello playground"
let prefix = s7.substring(to: s7.index(s7.startIndex, offsetBy: 2))
let postfix = s7.substring(from: s7.index(s7.startIndex, offsetBy: 2))


//DICTIONARIES:!!!
var d8: [String:Int] = ["a":1, "b":2, "c":3]
let d8Result1 = d8["a"]  //accessing with key
let d8Result2 = d8["gg"]  //accessing with key not exists

d8.removeValue(forKey: "a") //remove
d8

d8.updateValue( 33333, forKey: "c") //update value
d8


//some experimenting with [any] & flatmap; verify code for json object parsing
let a9: [Any] = [["a":1, "b":2], ["b":2, "c":3], "gg", [4,5,6]]

let a9Result1 = a9.flatMap { $0 as? [String: Any]}
a9Result1


// sorting, sorted = 自身
var a10 = [1,90,50]
a10.sorted() // ascending
a10.sorted { // descending
    $0 > $1
}
a10.sorted(by: > )





//holy shit, array so power full (i.e also == string.characters)

///     let numbers = [1, 2, 3, 4, 5]
///     print(numbers               .dropFirst(2))
///     // Prints "[3, 4, 5]"

///     let numbers = [1, 2, 3, 4, 5]
///     print(numbers               .dropLast(2))   ===> 和poplast不一样哦， pop会return数字
///     // Prints "[1, 2, 3]"


///     let numbers = [1, 2, 3, 4, 5]
///     print(numbers               .suffix(2))
///     // Prints "[4, 5]"

///     let numbers = [1, 2, 3, 4, 5]
///     print(numbers              .prefix(2))
///     // Prints "[1, 2]"

///     let numbers = [10, 20, 30, 40, 50]
///     if let lastNumber = numbers     .last {   ===> first is the same 
///         print(lastNumber)
///     }
///     // Prints "50"

///     let numbers = [3, 5, 7]
///     for number in numbers           .reversed() {   <<<<<<<
///         print(number)
///     }





let numbers = [ [10, 20, 30],
                [40, 50, 60],
                [70, 80, 90]]

numbers[1][2] //row & col

var intArray = [Int](repeating: 0, count: 2)

//used in grid
enum Mark {
    case cross
    case nought
    case empty
}

// game result for playerA
enum Result {
    case win,lose,draw
    case ongoing
}

enum Player {
    case playerA
    case playerB
}
var arr: [[Mark]] = Array(repeating: Array(repeating: .empty, count: 2), count: 3)

print(arr)

var currentPlayer = Player.playerB

currentPlayer = currentPlayer == .playerA ? .playerB : .playerA


