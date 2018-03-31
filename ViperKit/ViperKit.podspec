Pod::Spec.new do |s|
    s.name                  = 'ViperKit'
    s.version               = '1.0.0'
    s.summary               = 'The set of components to implement the VIPER architecture'
    s.homepage              = 'https://github.com/bonyadmitr/ViperKit'
    s.author                = { 'Bondar Yaroslav' => 'bonyadmitr@gmail.com' }
    s.license               = { :type => "MIT", :file => "LICENSE.md" }
    s.ios.deployment_target = '8.0'
    s.source                = {:git => '#{s.homepage}.git', :tag => "#{s.version}" }
    s.source_files          = 'ViperKit/*.swift'
end