// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: Configure the encoder for the requirement
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#configure-the-encoder-for-the-requirement

func configureForLowLatency(
    _ session: VTCompressionSession,
    bitsPerSecond: Int,
    framesPerSecond: Int,
    keyframeIntervalSeconds: Int
) -> Bool {
    let settings: [(CFString, CFTypeRef)] = [
        (kVTCompressionPropertyKey_RealTime, kCFBooleanTrue),
        (kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse),
        (kVTCompressionPropertyKey_AverageBitRate, bitsPerSecond as CFNumber),
        (kVTCompressionPropertyKey_ExpectedFrameRate, framesPerSecond as CFNumber),
        (kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,
         keyframeIntervalSeconds as CFNumber)
    ]
    return settings.allSatisfy { key, value in
        VTSessionSetProperty(session, key: key, value: value) == noErr
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
