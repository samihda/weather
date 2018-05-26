import Cocoa

class WeatherView: NSView {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var currentConditionsTextField: NSTextField!

    func update(_ weather: Weather) {
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(Int(truncating: weather.currentTemp))°C and \(weather.conditions)"
            self.imageView.image = NSImage(named: NSImage.Name(rawValue: weather.icon))
        }
    }

}
