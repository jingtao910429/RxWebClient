
Pod::Spec.new do |s|

  s.name         = "RxWebClient"
  s.version      = "0.1.3"
  s.summary      = "Rx & Moya of RxWebClient."

  s.description  = <<-DESC
                   上海燃点网络库封装
                   DESC

  s.homepage     = "https://github.com/jingtao910429/RxWebClient/tree/master/Example/RxWebClientExample"

  s.license      = "MIT"

  s.author       = "http://gw.2boss.cn"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/jingtao910429/RxWebClient.git"}

  s.source_files  = "Source/*.swift"

  s.frameworks = 'Foundation'

  s.requires_arc = true

  s.dependency "Alamofire", "~> 4.3"
  s.dependency "Moya", "~> 11.0"
  s.dependency "Moya/RxSwift"
  s.dependency "RxSwift", "~> 4.0"
  s.dependency "RxCocoa", "~> 4.0"
  s.dependency "SwiftyJSON", "~> 3.1.4"
  s.dependency "ObjectMapper", "~> 2.0.0"

end