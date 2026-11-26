// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: Media time is not wall-clock time
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#media-time-is-not-wall-clock-time

import AVFoundation
import CoreMedia
import VideoToolbox
import Synchronization

func captureAge(of sampleBuffer: CMSampleBuffer, on clock: CMClock) -> CMTime {
    CMTimeSubtract(
        CMClockGetTime(clock),
        CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
    )
}
