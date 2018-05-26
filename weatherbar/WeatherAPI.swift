import Foundation

struct Weather {
    var city: String
    var currentTemp: NSNumber
    var conditions: String
    var icon: String

    var description: String {
        return "\(city): \(currentTemp)°C and \(conditions)"
    }
}

class WeatherAPI {
    // let BASE_URL = "https://www.metaweather.com/api/location/search/?query="
    let BASE_URL = "https://www.metaweather.com/api/location/638242/"

    func fetchWeather(_ success: @escaping (Weather) -> Void) {
        let session = URLSession.shared
        // let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        // let url = URL(string: "\(BASE_URL)\(escapedQuery!)")
        let url = URL(string: "\(BASE_URL)")
        let task = session.dataTask(with: url!) { data, response, err in
            if let error = err {
                NSLog("Weather API error: \(error)")
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let weather = self.weatherFromJSONData(data!) {
                        success(weather)
                    }
                default:
                    NSLog("Weather API returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }

        task.resume()
    }

    func weatherFromJSONData(_ data: Data) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json: JSONDict

        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }

        var weatherList = json["consolidated_weather"] as! [JSONDict]
        var weatherDict = weatherList[0]

        let weather = Weather(
            city: json["title"] as! String,
            currentTemp: weatherDict["the_temp"] as! NSNumber,
            conditions: weatherDict["weather_state_name"] as! String,
            icon: "10d"
        )

        return weather
    }
}
