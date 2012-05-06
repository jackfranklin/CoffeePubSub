#Coffee PubSub

A very simple implementation of the Pub/Sub (or Observer) pattern in CoffeeScript.

# How to Use

Create a new instance:

```coffee
myApp = new Pubsub
```

Add a subscription:

```coffee
someFunc = ->
  console.log "foo"

myApp.sub "someId", "eventTitle", someFunc
```

Publish events:

```coffee
myApp.pub "eventTitle"
```

Send extra info with those events:

```coffee
someFunc = (data) ->
  console.log(data)

myApp.sub "elem1", "event1", someFunc
myApp.pub "event1", { foo: bar }
```

And unsubscribe:

```coffee
myApp.unSub "elem1", "event1"
```

#Tests

Unit tests are done with Mocha. Install with:

```
npm install -g mocha
```

Clone the repo, cd into it and:

```
npm install chai
```

Then run

```
mocha --compilers coffee:coffee-script -R spec
```


