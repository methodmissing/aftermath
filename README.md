# Aftermath

An example (and work in progress) Ruby implementation of CQRS (Command and Query Responsibility Segregation) as a reference for a [session](http://codebits.eu/intra/s/session/168) at [SAPO Codebits 2010](http://www.codebits.eu)

![Conceptual View](https://github.com/methodmissing/aftermath/raw/master/assets/cqrs.png)

# Implementation notes

A simple e-commerce / fulfillment Domain implementation with the bare minimum of framework
infrastructure.

Directory layout :

 * lib/aggregates       - aggregates with public behavior methods and private event handlers
 * lib/command_handlers - example
 * iib/commands         - commands (behaviors, task, intent)
 * lib/domain           - supporting domain code, mostly value objects
 * lib/events           - events (history of intent)
 * lib/framework        - infrastructure
 * lib/reporting        - read / query model - one per UI screen

Please refer to inline notes in /lib/framework in the interim whilst this README's being prepared.

# Caveats

A few very important details has been overlooked in favor of demonstrating patterns without
noise of technical masturbation.

 * Simple in process pub/sub channels
 * In memory sqlite backend for Event Storage
 * Hash repository for the Query / Reporting side
 * Duck typing for Command and Event handlers as Ruby doesn't have a formal type system
 * No coercion or validation for messages (Commands and Events)
 * No UI components (I might introduce a light Rack or Sinatra one)

# How to run the test suite

    git clone git@github.com:methodmissing/aftermath.git
    cd aftermath
    bundle install
    rake

# CQRS resources

  * [Starting point](http://abdullin.com/cqrs/)
  * [By Pål Fossmo](http://blog.fossmo.net/post/Command-and-Query-Responsibility-Segregation-(CQRS).aspx)
  * [CQRS and Event Sourcing](http://codebetter.com/blogs/gregyoung/archive/2010/02/13/cqrs-and-event-sourcing.aspx)
  * [Clarified CQRS](http://www.udidahan.com/2009/12/09/clarified-cqrs/)