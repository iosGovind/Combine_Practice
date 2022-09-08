import UIKit
import Combine

var subscribers = Set<AnyCancellable>()

// Here We are posting Notfications with  Combine
example(of: "Notification Center") {
    
    let center = NotificationCenter.default
    let name = Notification.Name("Testing Notification with Combine")
    
    let publisher = center.publisher(for: name)
    
    let subsciption = publisher
        .print()
        .sink { notification in
        print(notification.name)
            print(notification.object as? String as Any)
        print("Nofication recived")
    }
    
    center.post(name: name, object: "Hi")
    subsciption.cancel()
}

// Why :- Using Nofications Callback and clousers requires you to do all your work inside the callbackmethods or clousers. By migrating to the combine we can use operators to perform comman tasks such as Filting and all.

// Sink with reciveCompletion and reciveValue

example(of: "ReciveCompletion and ReciveValue") {
    let just = Just("Testing Just")
    just.print().sink { _ in
        print("Recived completion")
    } receiveValue: { value in
        print("reviced value", value)
    }.store(in: &subscribers)
}

// Using Assign one of the two buidin methods for subscribing to a publisher

example(of: "assing(to: on)") {
    class SomeObj {
        var data: String = "" {
            didSet {
                print("DidSet")
                print(oldValue)
                print(data)
                print("DidSet finished")
            }
            willSet {
                print("WillSet")
                print(newValue)
                print("Will set finished")
            }
        }
    }
    let obj = SomeObj()
    ["Govind" , "Solanki"].publisher
        .print()
        .assign(to: \.data, on: obj)
        .store(in: &subscribers)
}
example(of: "PassThrough Subject") {
    let publisher = PassthroughSubject<String, Never>()
    publisher.send("Got it")
    let subscriber = publisher.sink { recivedValue in
     print(recivedValue)
    }.store(in: &subscribers)
    publisher.send("After the subscription")
}

example(of: "CurrentValue") {
    let currentPublisher = CurrentValueSubject<Int , Never>(-1)
    currentPublisher.send(3)
    let subscriber = currentPublisher.sink { recivedValue in
     print(recivedValue)
    }.store(in: &subscribers)
    currentPublisher.send(4)
}
