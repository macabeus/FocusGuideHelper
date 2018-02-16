Pod::Spec.new do |s|
  s.name         = "FocusGuideHelper"
  s.version      = "0.1.1"
  s.summary      = "Clean, simple and beautiful segment bar for your AppleTv app"
  s.homepage     = "https://github.com/brunomacabeusbr/FocusGuideHelper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Bruno Macabeus" => "bruno.macabeus@gmail.com" }

  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/brunomacabeusbr/FocusGuideHelper.git", :tag => s.version }
  s.source_files = "FocusGuideHelper/FocusGuideHelper/*.swift", "FocusGuideHelper/FocusGuideHelper/*.xib"

end
