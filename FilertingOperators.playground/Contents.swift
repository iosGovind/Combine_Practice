import UIKit
import Combine

var subscribers = Set<AnyCancellable>()
example(of: "Filter") {
    let numbers = (1...10).publisher
    numbers
        .filter{
            $0.isMultiple(of: 3)
        }.sink { number in
            print(number)
        }.store(in: &subscribers)
}

example(of: "Remove Duplicates") {
    let words = " hey hey there! how are are you ? ? ".components(separatedBy: " ").publisher
    words.removeDuplicates()
        .sink { word in
            print(word)
        }.store(in: &subscribers)
}

example(of: "compactMap") {
    let value = ["a" , "12.4" , "5" , "$" , "er", "wef" , "3.454545456"].publisher
    
    value.compactMap { Float($0) }
        .sink { number in
            print(number)
        }.store(in: &subscribers)
}

// Omits the nil values
// Float has precision till 7th decimal only.

example(of: "IgnoreOutput") {
    let numbers = (1...1000).publisher
    
    numbers
        .ignoreOutput()
        .sink { print("Completed with \($0)")
        } receiveValue: {
            print("Value recived \($0)")
        }.store(in: &subscribers)
}

example(of: "First(where:)") {
    
    let numbers = (1...15).publisher
    numbers
        .print()
        .first (where: { $0 % 2 == 0 })
        .sink { print("Completed with \($0)")
        } receiveValue: { print("First value is \($0)")
        }.store(in: &subscribers)
}

example(of: "Last(where:)") {
    
    let numbers = (1...15).publisher
    numbers
        .print()
        .last(where: { $0 % 2 == 0 })
        .sink { print("Completed with \($0)")
        } receiveValue: { print("Last value is \($0)")
        }.store(in: &subscribers)
}

example(of: "Prefix") {
    
    let numbers = (1...15).publisher
    numbers
        .prefix(3)
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }.store(in: &subscribers)
}

example(of: "Prefix while") {
    
    let numbers = (3...15).publisher
    numbers
        .prefix { $0 <= 12 }
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }.store(in: &subscribers)
}
// Prefix while we can say till the condition is true

example(of: "Prefix untilOutputFrom") {
    
    let on = PassthroughSubject<Void, Never>()
    let strings = PassthroughSubject<String, Never>()
    
    strings
        .prefix(untilOutputFrom: on)
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }
        .store(in: &subscribers)
    
    ["a1" , "b1" , "c5" , "d45", "e65"]
        .forEach {
            strings.send($0)
            if $0.hasPrefix("d") {
                print("Condintion is success")
                on.send()
            }
        }
}
//  Untill we recive value on "on" publisher we will pass values to the downstream once we got value in "on" then it will not.

example(of: "Drop while") {
    
    let numbers = (1...10).publisher
    numbers
        .drop { $0 % 5 != 0 }
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }.store(in: &subscribers)
}

// Once conditio is true all the value drop will recive it will pass them to the downstream without even checking the condition

example(of: "Drop first") {
    
    let numbers = (1...10).publisher
    numbers
        .dropFirst(8)
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }.store(in: &subscribers)
}

// Drops then intial values till the count we passed


example(of: "Drop untilOutputFrom") {
    
    let on = PassthroughSubject<Void, Never>()
    let strings = PassthroughSubject<String, Never>()
    
    strings
        .drop(untilOutputFrom: on)
        .sink { print("Completed with \($0)")
        } receiveValue: { print("recived value is \($0)")
        }
        .store(in: &subscribers)
    
    ["a1" , "b1" , "c5" , "d45", "e65"]
        .forEach {
            strings.send($0)
            if $0.hasPrefix("c") {
                print("Condintion is success")
                on.send()
            }
        }
}

/*      Once we got value from On publisher then only it will start passing
        values to the downstream only before this all the values it wil omit
*/

/*
   Create a publisher that emits a collection of numbers from one to one hundred. Use filtering operators to skip the first 50 emitted by the publisher, values emitted by the publisher, take the next 20 values from the publisher, only take even numbers.

*/
example(of: "Challange") {
    let numbers = (1...100).publisher
    
    numbers.dropFirst(50)
        .prefix(20)
        .filter {
            $0 % 2 == 0
        }
        .sink { print($0)}
}
