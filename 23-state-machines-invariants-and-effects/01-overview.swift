// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Overview
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#overview

struct UploadFlags {
    var isUploading = false
    var isVerifying = false
    var isComplete = false
    var hasFailed = false
}
