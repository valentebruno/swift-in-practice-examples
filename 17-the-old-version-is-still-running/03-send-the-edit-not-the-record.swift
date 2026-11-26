// Swift in Practice — Edition #17: The Old Version Is Still Running
// Section: Send the edit, not the record
// https://swiftinpractice.com/editions/17-the-old-version-is-still-running/#send-the-edit-not-the-record

struct RenameRecipe: Encodable, Sendable {
    let title: String
    let expectedRevision: Int
}

struct StoredRecipe: Decodable, Equatable, Sendable {
    var title: String
    let status: String
    let servings: Int
    var revision: Int
}

enum RenameError: Error, Equatable {
    case revisionMismatch
}

actor RecipeStore {
    private var recipe: StoredRecipe

    init(_ recipe: StoredRecipe) {
        self.recipe = recipe
    }

    func rename(_ command: RenameRecipe) throws -> StoredRecipe {
        guard recipe.revision == command.expectedRevision else {
            throw RenameError.revisionMismatch
        }
        recipe.title = command.title
        recipe.revision += 1
        return recipe
    }

    func snapshot() -> StoredRecipe { recipe }
}
