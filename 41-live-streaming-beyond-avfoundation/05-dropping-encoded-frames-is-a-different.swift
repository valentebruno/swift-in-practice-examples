// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: Dropping encoded frames is a different decision
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#dropping-encoded-frames-is-a-different-decision

struct EncodedSendGate: Sendable {
    let maximumQueueAge: Duration
    private(set) var isWaitingForKeyframe = false
    private(set) var droppedFrameCount = 0

    init(maximumQueueAge: Duration) {
        self.maximumQueueAge = maximumQueueAge
    }

    enum Decision: Equatable, Sendable {
        case send
        case drop(requestKeyframe: Bool)
    }

    mutating func decide(isKeyframe: Bool, queueAge: Duration) -> Decision {
        if isWaitingForKeyframe {
            guard isKeyframe, queueAge <= maximumQueueAge else {
                droppedFrameCount += 1
                return .drop(requestKeyframe: isKeyframe)   // a stale keyframe: ask again
            }
            isWaitingForKeyframe = false
            return .send
        }

        if queueAge > maximumQueueAge {
            isWaitingForKeyframe = true
            droppedFrameCount += 1
            return .drop(requestKeyframe: true)
        }
        return .send
    }
}
