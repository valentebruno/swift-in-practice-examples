// Swift in Practice — Edition #44: Selecting 3D Parts Reliably on visionOS
// Section: Give every interactive part a domain identity
// https://swiftinpractice.com/editions/44-visionos-realitykit-part-selection/#give-every-interactive-part-a-domain-identity

extension Entity {
    var assemblyPart: AssemblyPart? {
        var current: Entity? = self
        while let entity = current {
            if let identity = entity.components[PartIdentity.self] {
                return identity.part
            }
            current = entity.parent
        }
        return nil
    }
}
