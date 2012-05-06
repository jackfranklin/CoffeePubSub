class Pubsub
  constructor: ->
    @subs = {}

  sub: (id, evt, cb) ->
    if @_isSubscribed evt
      sub = @subs[evt]
      sub.push {id: id, callback: cb}
    else
      @subs[evt] = [{id: id, callback: cb}]



  _isSubscribed: (evt) ->
    for sub of @subs
      return true if sub is evt
    false


  unSub: (id, evt) ->
    return if not @_isSubscribed evt
    sub = @subs[evt]
    for i in [0...sub.length]
      if sub[i].id is id
        sub[i] = null

    @_removeNull evt

  _removeNull: (evt) ->
    return if not @_isSubscribed evt
    newSubs = []
    subs = @subs[evt]
    for sub in subs
      newSubs.push sub unless sub is null

    if newSubs.length is 0
      delete @subs[evt]
    else
      @subs[evt] = newSubs


  pub: (evt, info) ->
    for key, val of @subs
      return false if not val?
      if key is evt
        for data in val
          data.callback(info)




root = exports ? window
root.Pubsub = Pubsub
