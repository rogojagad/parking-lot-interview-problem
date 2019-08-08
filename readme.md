# Parking Lot
___
Made by Rogo Jagad Alit, Informatics Departement Institut Teknologi Sepuluh Nopember batch 2015 for Go-Life Backend Engineer application test.


## Directory Structure
```
.
├── bin
│   ├── parking_lot
│   ├── run_functional_tests
│   └── setup
├── file_inputs.txt
├── functional_spec
│   ├── fixtures
│   │   └── file_input.txt
│   ├── Gemfile
│   ├── Gemfile.lock
│   ├── Rakefile
│   ├── README.md
│   └── spec
│       ├── end_to_end_spec.rb
│       ├── parking_lot_spec.rb
│       └── spec_helper.rb
├── Gemfile
├── Gemfile.lock
├── lib
│   ├── car.rb
│   ├── dependencies.rb
│   ├── main.rb
│   ├── parking_lot.rb
│   ├── parking_system.rb
│   └── utilities.rb
├── parking_lot
├── readme.md
└── spec
    ├── car_spec.rb
    ├── parking_lot_spec.rb
    ├── parking_system_spec.rb
    ├── spec_helper.rb
    └── utilities_spec.rb

```

## How to Run
The solution source code is in `lib`
 and the unit test for the solution is in `spec` folder.

This solution is using Ruby programming language and RSpec gem for unit testing.

Following are some instructions on how to run the solution:
* run `gem install bundle` on root directory to install `bundle` gem in your environment
* run `bin/setup` to install needed gem listed in `Gemfile` file and run the unit test.
* run the `bin/parking_lot {input file name}` in terminal to run the solution in file mode. Ex: `bin/parking_lot file_inputs.txt` to run the solution using `file_inputs.txt` as input source.
* run `bin/parking_lot` (wihout input file name) to run solution in interactive mode

## Class
Following are brief explanations of each class on this solution:
* **Car** : Implemented on `lib\car.rb` to represent Car which is parked on the parking lot. This class store the color and registration number of each car.

* **ParkingLot** : Implemented on `lib\parking_lot.rb` as Parking Lot area on which the Car is parked. This class uses array as the parking slot and implement the logic to park a car on certain slot, to look for cars with certain category (registration number or color) and to remove car from certain parking slot.

* **ParkingSystem** : Implemented on `lib\parking_system.rb`. This class act as interface between the user and the `ParkingLot`. This class uses `Utilities` class as a module to receive user's command and print the requested data to user on proper format. The processed user input is parsed then proper function matched user's query is called.

* **Utilities** : Implemented on `lib\utilities.rb`. This class receives and process user's command so it can be parsed by `ParkingSystem`. This class also used to format and print returned value,

## Problem Statement
I own a multi-storey parking lot that can hold up to 'n' cars at any given point in time.
Each slot is given a number starting at 1 increasing with increasing distance from the
entry point in steps of one. I want to create an automated ticketing system that allows
my customers to use my parking lot without human intervention.
When a car enters my parking lot, I want to have a ticket issued to the driver. The ticket
issuing process includes us documenting the registration number (number plate) and
the colour of the car and allocating an available parking slot to the car before actually
handing over a ticket to the driver (we assume that our customers are nice enough to
always park in the slots allocated to them). The customer should be allocated a parking
slot which is nearest to the entry. At the exit the customer returns the ticket which then
marks the slot they were using as being available.
Due to government regulation, the system should provide me with the ability to find out:
* Registration numbers of all cars of a particular colour.
* Slot number in which a car with a given registration number is parked.
* Slot numbers of all slots where a car of a particular colour is parked.

We interact with the system via a simple set of commands which produce a specific
output. Please take a look at the example below, which includes all the commands you
need to support - they're self explanatory. The system should allow input in two ways.
Just to clarify, the same codebase should support both modes of input - we don't want
two distinct submissions.
1) It should provide us with an interactive command prompt based shell where
commands can be typed in
2) It should accept a filename as a parameter at the command prompt and read the
commands from that file
