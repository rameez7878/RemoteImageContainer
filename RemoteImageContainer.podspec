Pod::Spec.new do |spec|

  spec.name                     = "RemoteImageContainer"
  spec.version                  = "1.1.0"
  spec.summary                  = "RemoteImageContainer loads the remote image and cache it for best user experience."
  spec.description              = "RemoteImageContainer loads the image from remote in an efficient way. It provides the customized activity indicator while loading image and once image loaded, it will cache that image for future efficiency in application."
  spec.homepage                 = "https://github.com/rameez7878"
  spec.license                  = { :type => 'MIT', :text => <<-LICENSE
                                        Copyright © 2021 Rameez Raja LLC.
                                    LICENSE
                                  }
  spec.author                   = { "Rameez Raja" => "rameezgcs333@gmail.com" }
  spec.ios.deployment_target    = "11.0"
  spec.source                   = { :git => "https://github.com/rameez7878/RemoteImageContainer.git", :tag => "#{spec.version}" }
  spec.source_files             = "RemoteImageContainer", "RemoteImageContainer/Source", "RemoteImageContainer/Extensions", "RemoteImageContainer/Helpers", "RemoteImageContainer/DownloadManager"
  spec.swift_versions           = ['5.0']

  spec.dependency                 'ShimmerSwift'

end
