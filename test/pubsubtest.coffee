chai = require 'chai'
expect = chai.expect

{Pubsub} = require '../src/pubsub'

fnDidFire = false
extraCallbackInfo = {}
hasFired = ->
  if fnDidFire
    fnDidFire = false
    return true
  else
    return false

someFn = ->
  fnDidFire = true

someFnWithInfo = (info) ->
  fnDidFire = true
  extraCallbackInfo = info


describe 'isSubscribed', ->
  myApp = new Pubsub
  it 'should return false if evt is not in subs', ->
    expect(myApp._isSubscribed("event1")).to.equal false
    myApp.sub "elem2", "myEvent", someFn
    expect(myApp._isSubscribed("event1")).to.equal false
  it 'should return true if evt is in subs', ->
    sub1 = myApp.sub "elem1", "myEvent", someFn
    expect(myApp._isSubscribed("myEvent")).to.equal true

describe 'a subscription', ->
  myApp = new Pubsub
  it 'should add subscriptions to the object', ->
    sub1 = myApp.sub "elem1", "myEvent", someFn
    expect(myApp.subs["myEvent"]).to.be.ok
    expect(myApp.subs["myEvent"].length).to.equal 1
  it 'it should add the id to the array for that event if the event already exists', ->
    sub2 = myApp.sub "elem2", "myEvent", someFn
    expect(myApp.subs["myEvent"].length).to.equal 2

describe 'unsubscribing',  ->
  myApp = new Pubsub
  it 'should not error if removing a non existant subscription', ->
    myApp.unSub "elem1", "myEvent"
    expect(myApp.subs).to.eql {}

  it 'should remove subscription fine', ->
    myApp.sub "elem1", "myEvent", someFn
    myApp.sub "elem1", "myEvent2", someFn
    expect(myApp.subs["myEvent"]).to.be.ok
    myApp.unSub "elem1", "myEvent"
    expect(myApp.subs["myEvent"]).to.not.be.ok
    expect(myApp.subs["myEvent2"]).to.be.ok


describe 'a publish', ->
  myApp = new Pubsub
  myApp.sub "elem1", "event1", someFn
  it 'should fire the callback', ->
    myApp.pub "event1"
    expect(hasFired()).to.be.ok

  it 'should send any extra data through with the callback', ->
    myApp.sub "elem2", "event2", someFnWithInfo
    myApp.pub "event2", foo: "bar"
    expect(hasFired()).to.be.ok
    expect(extraCallbackInfo.foo).to.equal "bar"

  it 'should not fire for an event that does not exist', ->
    myApp.pub "madeUpEvent"
    expect(hasFired()).to.not.be.ok

