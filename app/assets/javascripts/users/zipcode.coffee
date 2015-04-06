$ ->
  $('.jquery__address-zipcode').keyup (event) ->
    firstZipcode = $('#address_first_zipcode').val()
    lastZipcode = $('#address_last_zipcode').val()
    if firstZipcode.length == 3 && lastZipcode.length == 4
      zipCode = firstZipcode + lastZipcode
      $.ajax
        async:    true
        url:      "/account/addresses/fetch_address_with_zipcode/"
        type:     "GET"
        data:     {zipcode: zipCode}
        dataType: "json"
        context:  this
        success: (data) ->
          if data.prefecture
            $('#jquery__address-pref').val(data.prefecture)
            city = data.city + data.town
            $('#jquery__address-city').val(city)
    return