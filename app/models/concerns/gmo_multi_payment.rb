module GmoMultiPayment
  if Rails.env == "production"
  else
    Domain = "https://kt01.mul-pay.jp/"
    SiteID = "tsite00015404"
    SitePass = "cay5pqu1"
    ShopID = "tshop00016401"
    Tax = 0.08
    Capture = "CAPTURE"
    Void = "VOID"
    Return = "RETURN"
    ReturnNx = "RETURNNX"
  end
end
