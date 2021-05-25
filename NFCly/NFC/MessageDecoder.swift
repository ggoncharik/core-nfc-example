import Foundation
import CoreNFC

final class MessageDecoder {
    func decode(_ message: NFCNDEFMessage) -> [String] {
        return message.records.compactMap { payload in
            return self.decode(payload)
        }
    }
    
    private func decode(_ payload: NFCNDEFPayload) -> String? {
        let type = PayloadType(rawValue: String(data: payload.type, encoding: .utf8) ?? "")
        switch type {
            case .uri:
                return payload.wellKnownTypeURIPayload()?.absoluteString
            case .text:
                return payload.wellKnownTypeTextPayload().0
            default:
                return nil
        }
    }
}

enum PayloadType: String {
    case text = "T"
    case uri = "U"
    case unkown
    
    init(rawValue: String) {
        switch rawValue {
        case "U": self = .uri
        case "T": self = .text
        default: self = .unkown
        }
    }
}

