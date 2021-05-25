import Foundation
import CoreNFC

final class NFCWriter: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession?
    private var message: NFCNDEFMessage?
    
    func startSession(with message: NFCNDEFMessage) {
        self.message = message
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }

    private func write(_ message: NFCNDEFMessage, to tag: NFCNDEFTag) {
        tag.queryNDEFStatus() { (status: NFCNDEFStatus, _, error: Error?) in
            guard status == .readWrite else {
                self.session?.invalidate(errorMessage: "Can’t write on tag.")
                return
            }
            
            tag.writeNDEF(message) { (error: Error?) in
                if (error != nil) {
                    self.session?.invalidate(errorMessage: error!.localizedDescription)
                }
                self.session?.alertMessage = "Message successfully saved"
                self.session?.invalidate()
            }
        }
    }
}

extension NFCWriter {
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Couldn't read tag")
            return
        }
        guard let message = self.message else {
            session.invalidate(errorMessage: "Invalid Message")
            return
        }
        
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            self.write(message, to: tag)
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
}
