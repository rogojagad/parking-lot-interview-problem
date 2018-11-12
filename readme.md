## Directory Structure
```
.
+-- lib
|  +-- car.rb
|  +-- main.rb
|  +-- parking_lot.rb
|  +-- parking_system.rb
+-- spec
|  +-- parking_lot_spec.rb
|  +-- parking_system_spec.rb
|  +-- spec_helper.rb
+-- .gitignore
+-- .rspec
+-- file_inputs.txt
+-- Gemfile
+-- Gemfile.lock
+-- parking_lot
+-- parking_lot.c
+-- readme.md
```

## How to Run
This solution is using Ruby programming language and RSpec gem for unit testing.


Make sure you have install Bundle in your testing environment.

* run `bundle install` to install needed gem listed in `Gemfile` file
* run `rspec --init` in the root project directory to initialize the RSpec gem
* add `require_relative '../lib/dependencies'` in `spec/spec_helper.rb` just before `RSpec.configure do |config|`
* run the `parking_lot` executable to run the test, then run the solution
* run `./parking_lot` (wihout system parameter) to run solution in interactive mode
* run `./parking_lot [input filename]` to run solution in file mode


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
