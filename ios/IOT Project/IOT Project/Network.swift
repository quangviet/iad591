import SwiftUI

class Network: ObservableObject {
    @Published var buttonState: Bool = true
    @Published var lightSensor: Float = 0
    @Published var humidSensor: Float = 0
    @Published var proximitySensor: Bool = false
    @Published var tempSensor: Float = 0

    func getButton() {
        guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/button1") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let state = try JSONDecoder().decode(Feed.self, from: data)
                        print(state)
                        if (state.last_value == "ON") {
                            self.buttonState = true
                        } else {
                            self.buttonState = false
                        }
//                        self.users = decodedUsers
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
    func getLight() {
        guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/sensor1") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let state = try JSONDecoder().decode(Feed.self, from: data)
                        print(state)
                        self.lightSensor = Float(state.last_value) ?? 0.0
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
    func getHumid() {
        guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/sensor4") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let state = try JSONDecoder().decode(Feed.self, from: data)
                        print(state)
                        self.humidSensor = Float(state.last_value) ?? 0.0
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
    func getTemp() {
        guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/sensor3") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let state = try JSONDecoder().decode(Feed.self, from: data)
                        print(state)
                        self.tempSensor = Float(state.last_value) ?? 0.0
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
    func getProximity() {
        guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/sensor2") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let state = try JSONDecoder().decode(Feed.self, from: data)
                        print(state)
                        let v = Int(state.last_value) ?? 0
                        self.proximitySensor = (v == 1)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
