// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Test with data from the future
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#test-with-data-from-the-future

import Foundation
import Testing

@Test func aNewerRecordSurvivesAnEditByThisBuild() throws {
    let fromVersion4 = Data("""
    {"id":"6F9619FF-8B86-D011-B42D-00C04FC964FF","title":"Ragù",
     "status":"archived","writtenBySchema":4,
     "servings":{"count":4,"unit":"people"}}
    """.utf8)

    var recipe = try JSONDecoder().decode(Recipe.self, from: fromVersion4)
    #expect(recipe.status == .unrecognized("archived"))

    recipe.title = "Ragù alla bolognese"
    let written = try JSONEncoder().encode(recipe)
    let fields = try JSONDecoder().decode([String: JSONValue].self, from: written)

    #expect(fields["servings"] == .object(["count": .number(4), "unit": .string("people")]))
    #expect(fields["status"] == .string("archived"))
    #expect(fields["writtenBySchema"] == .number(3))
}
