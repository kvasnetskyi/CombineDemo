# Combine
**Combine** – unified declarative framework for handling values over time.

You can find more information in a [presentation](https://drive.google.com/file/d/1blu_qidrbC74edCBHP-eM7IvBEfeCwnH/view?usp=sharing) and video:
- [Theory](https://chiswdevelopment.sharepoint.com/sites/iOSteam/Shared%20Documents/General/Recordings/Meeting%20in%20_General_-20210616_110923-Meeting%20Recording.mp4?web=1)
- [Practise](https://chiswdevelopment.sharepoint.com/:v:/r/sites/iOSteam/Shared%20Documents/General/Recordings/%D0%A1%D0%BE%D0%B1%D1%80%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B2%20%D0%9E%D0%B1%D1%89%D0%B8%D0%B9-20210617_120533-Meeting%20Recording.mp4?csf=1&web=1&e=y7WqZP)

# Components
[Publisher](#publisher) – describes how values and errors are created. Registers the subscriber.

[Subscriber](#subscriber) – signed to the publisher to respond to values received or to a completion event.

[Operator](#operators) – a publisher method that returns either the same or a converted new publisher.

# Publisher
###### Value Type
The publisher issues values to one or more subscribers. The values can be of three types:
* Output
* Successful Completion
* Failure Completion

The publisher may output zero or more output values. But if it ever completes, either successfully or with an error, it will not produce any other events.

![PublisherProtocol](https://user-images.githubusercontent.com/67891065/122563364-c9ffab80-d04c-11eb-8214-670533566c9b.png)

The publisher protocol contains two associated types:<br/>
Output - the value it will produce.<br/>
Failure - the error it may terminate with.

There is also a ```subscribe``` method inside which a subscriber is passed, whose Input and Error values must match those of the publisher. This method registers the subscriber.

# Subscriber
###### Reference Type
A protocol that declares a type that can receive input from a publisher.

![SubscriberProtocol](https://user-images.githubusercontent.com/67891065/122563922-75106500-d04d-11eb-8f5e-39343eff2a86.png)

The subscriber protocol contains two types:<br/>
Input - the data it receives.<br/>
Failure - the error it receives.

Also, Subscriber has three methods, which will be called by the publisher:
* ```receive(subscription: Subscription)```<br/>
Called when the publisher registered the subscriber.

* ```receive(_ input: Input) -> Subscribers.Demand```<br/>
Called when the publisher sends data to the subscriber, and returns to the publisher the maximum amount of data the subscriber can still receive.

* ```receive(completion: Subscribers.Completion<Failure>)```<br/>
Called when the publisher wants to pass the completion to the subscriber.

# The Pattern
![ThePattern](https://user-images.githubusercontent.com/67891065/122569199-2d8cd780-d053-11eb-9f0e-b42b978d7ce9.png)

1. Subscriber is attached to Publisher.
2. Publisher sends a Subscription
3. Subscriber requests N values
4. Publisher sends N values or less
5. Publisher sends completion

# Convenience Publishers
The framework has ready-made publishers, designed to be easy to use. We'll look at a few of them; the rest can be found in Apple's documentation.

**Future**<br/>
A publisher who eventually produces one value and then completes or fails.

![Future](https://user-images.githubusercontent.com/67891065/122570457-7002e400-d054-11eb-8fae-eba54dfa7b80.png)

**Deferred**<br/>
A publisher who waits for a subscription before launching a provided closure to create a publisher for a new subscriber.

In practice, it is very often used in conjunction with Future. If you wrap Future in Deferred, a new Future will be created with each new subscription, and produce a new result.

![Deferred](https://user-images.githubusercontent.com/67891065/122570492-798c4c00-d054-11eb-997c-56046664ebaa.png)

**Just**<br/>
A publisher that sends the output to each subscriber only once and then completes the job.

![Just](https://user-images.githubusercontent.com/67891065/122570587-8dd04900-d054-11eb-9e5f-aaa4126da779.png)

**Fail**<br/>
Publisher, which terminates immediately with the specified error.

![Fail](https://user-images.githubusercontent.com/67891065/122570636-96c11a80-d054-11eb-9d3d-db49786c4481.png)

# Foundation Publishers
Apple has also introduced some publishers to the Foundation. You can create publishers from:
* NotificationCenter
* KVO instance
* URLSession.dataTaskPublisher
* Result

![FoundationPublishers](https://user-images.githubusercontent.com/67891065/122571136-14852600-d055-11eb-9dc4-622b24294f58.png)

# Subjects
Publishers that enable outside callers to send multiple values asynchronously to subscribers, with or without a starting value.

These are most often used to connect Combine with imperative code. For example, when you have a delegate method and you want to create a publisher that will publish some data, exactly at the moment when this method is called.

Subjects have a ```send``` method that you can use to send the data you want, a completion or an error.

There are two types of ыubjects in the framework:
* PassthroughSubject<br/>
Transmits the data to the subscribers.

* CurrentValueSubject<br/>
Transmits data to subscribers and stores its last state.

# Subscribers
Combine provides the following subscribers as operators on the Publisher type:

* ```sink(receiveCompletion:receiveValue:)```<br/>
Attaches a subscriber with closure-based behavior.

* ```sink(receiveCompletion:receiveValue:)```<br/>
Assigns each element from a publisher to a property on an object.

Each of these operators returns a subscription to you as an *AnyCancellable* object. You store them as properties or in the set. If at some point you no longer need a subscription, you can call the cancel method on this object.

# Operators
###### Value Type
A publisher method that describes the behaviour when values change.

Each Combine operator returns a publisher. It receives the upstream values, manipulates the data, and then sends that data downstream. There are many operators that Apple has divided into different categories, depending on what they do.

* Functional transformations
* List operations
* Error handling
* Thread or queue movement
* Scheduling and time

A list of all operators can be found in Apple's documentation.

# Architectures
Apple has created Combine, which allows you to natively use binding. SwiftUI also works with Combine. This is why using architectures that work with binding has become more attractive than ever.

These include:
* MVVM
* Redux
* MVI

Instead of using closure, Combine allows you to return Future as a deferred result. Subjects and @Published property wrapper can easily be used as states.

# Combine vs RXSwift
**RXSwift advantages**
* IOS Version
One of the benefits of RXSwift is support for iOS 8 and above. Whereas Combine supports iOS 13 and above.

* Operators
RxSwift gives us a greater choice of operators than Combine.

**Combine advantages**
* Performance
Combine is more performant than RXSwift.

* Native framework
Apple will develop Combine and you don't need to install dependencies.

**It is neither an advantage nor a disadvantage**
* Failure Type
Publisher must explicitly specify the type of error, while Observables does not. This makes it easier to write code with RXSwift, but complicates error handling.

If you are familiar with RXSwift and want to compare components with Combine, you can do so via the [link](https://github.com/CombineCommunity/rxswift-to-combine-cheatsheet)

Developed By
------------

* Kvasnetskyi Artem, Savchenko Roman, Kosyi Vlad, CHI Software

License
--------

Copyright 2021 CHI Software.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
