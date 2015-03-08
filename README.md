# TeplateImageView
Excellent placeholder for your image views. Tell your designer what to do using the storyboard.

## Inspiration
There must be times that you are putting an image view into your app of some purpose but you don't have the image. Not long after you are digging through the internet for image but you forget the dimension or even the purpose. This `TemplateImageView` is the perfect solution.

![Screenshot](https://raw.githubusercontent.com/DJBen/TemplateImageView/master/screenshot-storyboard.png "Screen shot 1")

It does not only tell you the dimensions (of your choice) but it also contains a descriptive text field for you to illustrate the purpose of image being put there. You can your designer can communicate using the storyboard!

## Usage
For now: download `Classes/TemplateImageView.swift` and plug it into your code. Create a new `UIView` and change its class into `TemplateImageView`.

Cocoapods incoming.

## Properties
It provides many `@IBInspectable` properties for you to change in the storyboard of Xcode 6+ on the fly.

- `image`: The image of the image view. That's the most important thing an image view does. If the image is not `nil`, all the template size markers and texts will be hidden.
- `show1x`, `show2x`, `show3x`: whether to show size mark @1x, @2x, or @3x.
- `simpleSizeMark: Bool`: `true` to just show the dimension at @1x regardless of the three options above; otherwise show as the three options above specified.
- `descriptiveText: String`: The descriptive text at the center of template view.
- `descriptiveTextSize: CGFloat`: The size of the descriptive text.
- `descriptiveTextColor: UIColor`: The color of the descriptive text.
- `sizeMarkTextColor: UIColor`: The text color of the size mark, like `50@1x 100@2x`.
- `sizeMarkColor: UIColor`: The size mark color.
- `sizeMarkIndentation: CGFloat`: The vertical indentation of the horizontal size mark, or the horizontal indentation of the vertical size mark.
- `sizeMarkHeight: CGFloat`: The height of size marks.
- `sizeMarkTopPadding: CGFloat`: The padding between size mark text and the size mark bar.
