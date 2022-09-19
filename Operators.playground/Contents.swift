import UIKit
import Combine

var subscribers = Set<AnyCancellable>()

// MARK: Collect Operator
example(of: "Collect Operator") {
    ["A","B", "C","D"].publisher
        .collect()
        .sink { char in
            print(char)
        }
        .store(in: &subscribers)
}


example(of: "Collect Operator with Passthrough") {
    let passThrough = PassthroughSubject<Int , Never>()
    passThrough
    // .print()
        .collect()
        .sink { char in
            print(char)
        }
        .store(in: &subscribers)
    passThrough.send(10)
    passThrough.send(15)
    passThrough.send(20)
    passThrough.send(completion: .finished)
}
//Its the perfect use of Collect operator where all the values sent by the publiser are collected and will get returned when publisher gets completion.

// MARK: Map Operator
example(of: "Map Operator") {
    let array:[Int] = [1,2,3,5,6,7]
    array.publisher
        .map({ $0 * 2})
        .sink { number in
            print(number)
        }
}

// MARK: ReplaceNil Operator
example(of: "Replace Operator") {
    let array:[Int?] = [1,2,3,nil,6,7]
    array.publisher
        .replaceNil(with: 0)
    //.map({ $0 * 2})
        .sink { number in
            print(number as Any)
        }
}

// MARK: ReplaceEmpty Operator
example(of: "ReplaceEmpty Operator") {
    let array:[Int?] = []
    array.publisher
        .replaceEmpty(with: 0)
        .sink { number in
            print(number as Any)
        }.store(in: &subscribers)
}

// MARK: ReplaceEmpty Operator
example(of: "ReplaceEmpty Operator") {
    let empty = Empty<Int, Never>()
    empty
        .replaceEmpty(with: 0)
        .sink { number in
            print(number)
        }
}
// MARK: ReplaceEmpty Operator
example(of: "Scan Operator") {
    let array = [1,2,3,4,5,6,7].publisher
    array
        .scan(0) {
            return $0 + $1 }
        .sink { num in
            // print(num)
        }.store(in: &subscribers)
}
// It stores the last value and made it available for next iteration.
// and the last num will be what we are returing for scan clouser
// in this case
/*
 Last   Next
 0      1
 1      2
 3      3
 6      4
 10     5
 15     6
 21     7
 */

example(of: "Flatmap") {
    [1, 2, 3,4].publisher.flatMap({ int in
        return (0..<int).publisher
    }).sink(receiveCompletion: { _ in }, receiveValue: { value in
        print("value: \(value)")
    }).store(in: &subscribers)
}

example(of: "FlatMap  combine two publishers") {
    let chatter = Chatter(name: "Chatter", message: "Hi I am a chatter")
    let james = Chatter(name: "James", message: "Hi I am James ")
    
    let chat = CurrentValueSubject<Chatter , Never>(chatter)
    chat
        //.flatMap{ $0.message }
        .sink { msg in
            print( msg)
        }.store(in: &subscribers)
    chatter.message.value = "Hi again"
    chat.value = james
    chatter.message.value = "Hi from James"
}

