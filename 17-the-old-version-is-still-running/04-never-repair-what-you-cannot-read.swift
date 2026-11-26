// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Never repair what you cannot read
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#never-repair-what-you-cannot-read

let recipe = (try? decoder.decode(Recipe.self, from: data)) ?? Recipe.empty
