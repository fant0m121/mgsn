$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] != undefined
      if !o[@name].push
        o[@name] = [ o[@name] ]
      o[@name].push @value or ''
    else
      o[@name] = @value or ''
    return
  o

# ---
# generated by js2coffee 2.1.0
