// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Test with data from the future
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#test-with-data-from-the-future

@Test func aRenameLeavesNewerFieldsAlone() async throws {
    let payload = Data("""
    {"title":"Ragu","status":"archived","servings":4,"revision":7}
    """.utf8)
    let store = RecipeStore(try JSONDecoder().decode(StoredRecipe.self, from: payload))
    let command = RenameRecipe(title: "Ragù", expectedRevision: 7)

    let body = try JSONEncoder().encode(command)
    let sent = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
    #expect(Set(sent.keys) == ["title", "expectedRevision"])

    let saved = try await store.rename(command)
    #expect(saved == StoredRecipe(title: "Ragù", status: "archived", servings: 4, revision: 8))

    await #expect(throws: RenameError.revisionMismatch) {
        try await store.rename(command)
    }
    #expect(await store.snapshot() == saved)
}
