// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

if device == .iPhoneDuo {
    DuoLayout()
} else if device == .iPad {
    PadLayout()
} else {
    PhoneLayout()
}
