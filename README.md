# PDFPresenter
iOS PDF Presenter written in Swift

## Features
- Outline of the pdf file
- Share pdf with others or store on local iOS devices
- Page count
- More coming soon... 😄

## Installation
### CocoaPods
To integrate PDFPresenter into your Xcode project using CocoaPods, specify it in your Podfile:

```bash
pod 'PDFPresenter'
```
 https://cocoapods.org/pods/PDFPresenter
 
## Usage
###Paremeter: Title and URL of the pdf

```Swift
import PDFPresenter

let vc =  PDFViewController(pdf: pdfItem(title: "{Insert PDF Title here}", pdfURL: "{Insert PDF URL here}"))
self.navigationController?.pushViewController(vc, animated: true)
```

## Customization
Coming soon

## Contributing
For major changes, please open an issue first to discuss what you would like to change.

## Libraries used
UIKit, PDFKit

## License
[MIT](https://choosealicense.com/licenses/mit/)

## More
Please give a star as support, much love❤️!
