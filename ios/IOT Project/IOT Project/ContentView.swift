//
//  ContentView.swift
//  IOT Project
//
//  Created by Quang Viet on 25/04/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    @State var currentDate = Date.now
        let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center) {
                VStack {
                    HStack(alignment: .top) {
                        Text("Nhóm 8:")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 20.0)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text("Phạm Quang Việt + Kiều Văn Xuân")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 20.0)
                        Spacer()
                    }
                }
//                Button() {
//                } label: {
//                    Image(systemName: "bell.fill").font(.title3)
//                }
////                .buttonStyle(.bordered)
//                .padding(.all, 12.0)
//                .background(.white)
//                .cornerRadius(8)
//                .padding(.trailing, 20)
            }
            .padding(.bottom)
            HStack {
                Button("Toggle", action: {
                    // Encode your JSON data
                    let jsonString = "{ \"command\" : \"sdm.devices.commands\", \"params\" : { \"commandName\" : \"cmdValue\" } }"
                    
                    var parameters = ["value": "ON"]
                    if network.buttonState {
                        parameters["value"] = "OFF"
                    }
                    
                    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                    
                    // Send request
                    guard let url = URL(string: "https://io.adafruit.com/api/v2/quangviet/feeds/button1/data.json?X-AIO-Key=aio_OMGE05PPsNTa0waG2mNwStvtN8Xz") else {return}
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.httpBody = httpBody
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("token", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    }
                    task.resume()
                })

                Toggle("LED Backlight", isOn: $network.buttonState)
                Spacer()
            }
            .padding(20.0)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            
            HStack {
                Text("Light: " + String(network.lightSensor) + " %")
                Spacer()
            }
            .padding(20.0)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            HStack {
                Text("Humidity: " + String(network.humidSensor) + " %")
                Spacer()
            }
            .padding(20.0)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            HStack {
                Text("Temperature: " + String(network.tempSensor) + " C")
                Spacer()
            }
            .padding(20.0)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            HStack {
                Text("Proximity: " + String(network.proximitySensor) + "")
                Spacer()
            }
            .padding(20.0)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            Spacer()
        }
//        .padding()
        .padding(.top, 20.0)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.942))
        .onAppear {
            network.getButton()
            network.getLight()
            network.getHumid()
            network.getProximity()
            network.getTemp()
        }
        .onReceive(timer) { input in
            network.getButton()
            network.getLight()
            network.getHumid()
            network.getProximity()
            network.getTemp()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
