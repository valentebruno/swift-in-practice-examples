// Swift in Practice — Edition #35: Core Bluetooth in Production: From Connection to a Live Reading
// Section: Give “connect now” a deadline
// https://swiftinpractice.com/editions/35-corebluetooth-in-production/#give-connect-now-a-deadline

@MainActor
final class SensorLink: NSObject {
    private(set) var phase: LinkPhase = .waitingForRadio
    private var central: CBCentralManager!
    private var pending: CBPeripheral?
    private var deadline: Task<Void, Never>?

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }

    func connect(_ peripheral: CBPeripheral, within limit: Duration) {
        let attempt = UUID()
        send(.connectRequested(attempt: attempt, peripheral: peripheral.identifier))
        guard case .connecting(let current, _) = phase, current == attempt else {
            return                           // refused, or an attempt is already running
        }
        pending = peripheral                 // Core Bluetooth does not retain it for you
        central.connect(peripheral)

        deadline?.cancel()
        deadline = Task { [weak self] in
            try? await Task.sleep(for: limit)
            guard !Task.isCancelled, let self else { return }
            self.send(.connectDeadlinePassed(attempt: attempt))
            if case .unavailable = self.phase, let pending = self.pending {
                self.central.cancelPeripheralConnection(pending)
                self.pending = nil
            }
        }
    }

    fileprivate func send(_ event: LinkEvent) {
        phase = reduce(phase, event)
    }
}

extension SensorLink: CBCentralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        MainActor.assumeIsolated {
            send(state == .poweredOn ? .radioPoweredOn : .radioReset)
        }
    }

    nonisolated func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let id = peripheral.identifier
        MainActor.assumeIsolated {
            deadline?.cancel()
            send(.connected(peripheral: id))
        }
    }
}
