Pod::Spec.new do |s|
    s.name             = 'EYLoginSDK'
    s.version          = '1.2.2'
    s.summary          = 'A short description of EYLoginSDK.'
    s.swift_version = '5.0'
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = 'EyuLibrary'
    
    s.homepage         = 'https://github.com/EyugameQy/EyuLibrary-ios'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    #s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Tangmingding' => 'erictang@eyugame.com' }
    s.source           = { :git => 'https://github.com/www19949212008/EYLoginSDK.git', :tag => s.version.to_s }
    #s.prefix_header_file = 'EyuLibrary-ios/Classes/PrefixHeader.pch'
    s.ios.deployment_target = '10.0'
    s.static_framework = true
    
    s.subspec 'Core' do |c|
        c.source_files = 'EYLoginSDK/Classes/Core/**/*'
    end
    
    s.subspec 'Basic' do |b|
        c.source_files = 'EYLoginSDK/Classes/Basic/**/*'
    end
end
