// Swift in Practice — Edition #39: From Camera Frame to Map Pin
// Section: A score is not a probability until you have checked
// https://swiftinpractice.com/editions/39-location-intelligence-3-vision-evidence/#a-score-is-not-a-probability-until-you-have-checked

struct LabeledPrediction: Sendable {
    let score: Float
    let wasCorrect: Bool
}

func precision(
    atOrAbove threshold: Float,
    in predictions: [LabeledPrediction]
) -> (precision: Double, coverage: Double)? {
    let accepted = predictions.filter { $0.score >= threshold }
    guard !accepted.isEmpty, !predictions.isEmpty else { return nil }

    let correct = accepted.count { $0.wasCorrect }
    return (
        Double(correct) / Double(accepted.count),
        Double(accepted.count) / Double(predictions.count)
    )
}
