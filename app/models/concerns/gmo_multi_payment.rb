module GmoMultiPayment
  if Rails.env == "production"
  else
    Domain = "https://kt01.mul-pay.jp/"
    SiteID = "tsite00017219"
    SitePass = "gfy1md53"
    ShopID = "tshop00018367"
    ShopPass = "kzm7ss7m"
    Tax = 0.08
    Check = "CHECK"
    Auth = "AUTH"
    Sales = "SALES"
    Capture = "CAPTURE"
    Void = "VOID"
    Return = "RETURN"
    ReturnNx = "RETURNNX"
  end
end
