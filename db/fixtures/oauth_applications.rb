[{
  id: 1,
  name: 'FiNC App',
  consumer_key: Settings.oauth_applications.finc_app.consumer_key,
  consumer_secret: '',
  redirect_uri: 'https://app-dietcoach.finc.co.jp'}
].each { |s| OauthApplication.seed(s) }
