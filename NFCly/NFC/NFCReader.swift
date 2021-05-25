import Foundation
import CoreNFC

final class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession?
    private var message: NFCNDEFMessage?
    private var successReading: ((NFCNDEFMessage) -> ())?
    
    func startSession(onSuccess: @escaping ((NFCNDEFMessage) -> ())) {
        successReading = onSuccess
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    private func read(_ tag: NFCNDEFTag) {
         tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
             guard error == nil else {
                 self.session?.invalidate(errorMessage: error!.localizedDescription)
                 return
             }
             guard let message = message else {
                 self.session?.invalidate(errorMessage: "There's no message")
                 return
             }
             self.successReading?(message)
             self.session?.alertMessage = "Message successfully read"
             self.session?.invalidate()
         }
     }
}


extension NFCReader {
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Couldn't read tag")
            return
        }
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            self.read(tag)
        }
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
}
