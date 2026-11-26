// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: Configure the encoder for the requirement
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#configure-the-encoder-for-the-requirement

struct EncoderConfigurationError: Error {
    let property: String
    let status: OSStatus
}

func configureForLowLatency(
    _ session: VTCompressionSession,
    bitsPerSecond: Int,
    framesPerSecond: Int,
    keyframeIntervalSeconds: Int
) throws {
    let settings: [(CFString, CFTypeRef)] = [
        (kVTCompressionPropertyKey_RealTime, kCFBooleanTrue),
        (kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse),
        (kVTCompressionPropertyKey_AverageBitRate, bitsPerSecond as CFNumber),
        (kVTCompressionPropertyKey_ExpectedFrameRate, framesPerSecond as CFNumber),
        (kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,
         keyframeIntervalSeconds as CFNumber)
    ]
    for (key, value) in settings {
        let status = VTSessionSetProperty(session, key: key, value: value)
        guard status == noErr else {
            throw EncoderConfigurationError(property: key as String, status: status)
        }
    }
}

func forcedKeyframeOptions() -> CFDictionary {
    [kVTEncodeFrameOptionKey_ForceKeyFrame: true] as CFDictionary
}

func isKeyframe(_ encoded: CMSampleBuffer) -> Bool {
    guard let attachments = CMSampleBufferGetSampleAttachmentsArray(
        encoded, createIfNecessary: false
    ) as? [[CFString: Any]], let first = attachments.first else {
        return true
    }
    return !(first[kCMSampleAttachmentKey_NotSync] as? Bool ?? false)
}
