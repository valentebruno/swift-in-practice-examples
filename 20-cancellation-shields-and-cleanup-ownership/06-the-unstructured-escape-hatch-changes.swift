// Swift in Practice — Edition #20: The Work Is Cancelled. The Cleanup Isn’t.
// Section: The unstructured escape hatch changes the contract
// https://swiftinpractice.com/editions/20-cancellation-shields-and-cleanup-ownership/#the-unstructured-escape-hatch-changes-the-contract

func releaseSurvivingCancellation(_ log: EventLog) async {
    if #available(macOS 27.0, iOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
        await withTaskCancellationShield {
            await releaseLease(log)
        }
    } else {
        await Task { await releaseLease(log) }.value
    }
}
