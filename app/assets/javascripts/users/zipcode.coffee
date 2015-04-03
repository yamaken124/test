$ ->
  $('#jquery__address-zipcode').keyup (event) ->
    paramsCode = $('#jquery__address-zipcode').val()
    if paramsCode.length >= 7
      $.ajax
        async:    true
        url:      "/account/addresses/fetch_address_with_zipcode/"
        type:     "GET"
        data:     {zipcode: paramsCode}
        dataType: "json"
        context:  this
        success: (data) ->
          if data.prefecture
            $('#jquery__address-pref').val(data.prefecture)
            city = data.city + data.town
            $('#jquery__address-city').val(city)
    return