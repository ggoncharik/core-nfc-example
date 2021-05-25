import Foundation
import CoreNFC

final class MessageEncoder {
    
    func message(payloads: [NFCNDEFPayload] ...) -> NFCNDEFMessage? {
        let payloads = payloads.reduce([], +)
        return (payloads.count > 0) ? NFCNDEFMessage(records: payloads) : nil
    }
    
    func payloads(from strings: [String]) -> [NFCNDEFPayload] {
        return strings.compactMap { string in
            return NFCNDEFPayload.wellKnownTypeTextPayload(
                string: string,
                locale: Locale(identifier: "En")
            )
        }
    }
    
    func payloads(from urls: [URL]) -> [NFCNDEFPayload] {
        return urls.compactMap { url in
            return NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
        }
    }
}

