import SwiftUI

struct ContentView: View {
    private let writer = NFCWriter()
    private let reader = NFCReader()
    
    @State private var data: [String] = []
    
    var body: some View {
        VStack {
            if !data.isEmpty {
                List(data, id: \.self) { payload in
                    Text(payload)
                        .font(.headline)
                }
            } else {
                Spacer()
            }
            HStack {
                Button("Read", action: readMsg)
                Button("Write", action: writeIG)
            }.padding()
        }
    }
    
    private func writeIG() {
        let encoder = MessageEncoder()
        let name = "Georgei Goncharik"
        guard let url = URL(string: "instagram://user?username=g0shka69") else {
            print("error")
            return
        }
        guard let message = encoder.message(payloads: encoder.payloads(from: [name]),
                                            encoder.payloads(from: [url]))
        else {
            return
        }
        writer.startSession(with: message)
    }
    
    private func readMsg() {
        self.data = []
        reader.startSession(onSuccess:{ message in
            let decoder = MessageDecoder()
            DispatchQueue.main.async {
                self.data = decoder.decode(message)
            }
        })
    }
}
