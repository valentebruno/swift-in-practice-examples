// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: What the capture output can and cannot bound
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#what-the-capture-output-can-and-cannot-bound

final class CaptureAdapter: NSObject,
    AVCaptureVideoDataOutputSampleBufferDelegate, Sendable {

    let mailbox = LatestFrameMailbox<CapturedFrame>()
    private let dropReasons = Mutex<[String: Int]>([:])

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        mailbox.offer(CapturedFrame(sampleBuffer: sampleBuffer))
    }

    func captureOutput(
        _ output: AVCaptureOutput,
        didDrop sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        let reason = CMGetAttachment(
            sampleBuffer,
            key: kCMSampleBufferAttachmentKey_DroppedFrameReason,
            attachmentModeOut: nil
        ) as? String ?? "unknown"
        dropReasons.withLock { $0[reason, default: 0] += 1 }
    }

    var dropSummary: [String: Int] {
        dropReasons.withLock { $0 }
    }
}
