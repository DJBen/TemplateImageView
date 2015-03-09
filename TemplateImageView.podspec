Pod::Spec.new do |s|


  s.name         = "TemplateImageView"
  s.version      = "0.1.0"
  s.summary      = "An excellent placeholder of image view with customizable size marks and a descriptive text."

  s.description  = <<-DESC
                   Template image view provides placeholding overlay on a image view. Sometimes you may not have the suitable image, so this view will be the perfect placeholder at that situation.

                   It displays size marks and a descriptive text with custom font / color / size. Able to change specs through Xcode 6+ interface builder without running the app.

                   DESC

  s.homepage     = "https://github.com/DJBen/TemplateImageView"
  s.screenshots  = "https://raw.githubusercontent.com/DJBen/TemplateImageView/master/screenshot-storyboard.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "DJBen" => "lsh32768@gmail.com" }
  s.social_media_url   = "https://www.facebook.com/HelloDJBen"

  s.platform     = :ios, "8.3"

  s.source       = { :git => "https://github.com/DJBen/TemplateImageView.git", :tag => "0.1.0" }

  s.source_files  = "TemplateImageView/Classes/*.*"
  s.requires_arc = true


end
