// Swift in Practice — Edition #35: Core Bluetooth in Production: From Connection to a Live Reading
// Section: Give “connect now” a deadline
// https://swiftinpractice.com/editions/35-corebluetooth-in-production/#give-connect-now-a-deadline

@MainActor
final class SensorLink: NSObject {
    private(set) var phase: LinkPhase = .waitingForRadio
    private var central: CBCentralManager!
    private var pending: CBPeripheral?
    private var connected: CBPeripheral?
    private var deadline: Task<Void, Never>?

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }

    func connect(_ peripheral: CBPeripheral, within limit: Duration) {
        guard pending == nil, connected == nil else { return }
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
            guard case .connecting(let current, _) = self.phase,
                  current == attempt, let pending = self.pending else { return }
            self.send(.connectDeadlinePassed(attempt: attempt))
            self.central.cancelPeripheralConnection(pending)
            // Keep pending until Core Bluetooth acknowledges the attempt ended.
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
            if state == .poweredOn {
                send(.radioPoweredOn)
            } else {
                deadline?.cancel()
                deadline = nil
                pending = nil
                connected = nil
                send(.radioReset)
            }
        }
    }

    nonisolated func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let id = peripheral.identifier
        MainActor.assumeIsolated {
            guard let peripheral = pending, peripheral.identifier == id else { return }
            guard case .connecting(_, let expected) = phase, expected == id else {
                self.central.cancelPeripheralConnection(peripheral)
                return
            }
            deadline?.cancel()
            deadline = nil
            connected = peripheral
            pending = nil
            send(.connected(peripheral: id))
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?
    ) {
        let id = peripheral.identifier
        MainActor.assumeIsolated {
            guard pending?.identifier == id else { return }
            deadline?.cancel()
            deadline = nil
            pending = nil
            send(.connectionFailed(peripheral: id))
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?
    ) {
        let id = peripheral.identifier
        MainActor.assumeIsolated {
            if pending?.identifier == id {
                deadline?.cancel()
                deadline = nil
                pending = nil
            }
            if connected?.identifier == id { connected = nil }
            send(.disconnected(peripheral: id))
        }
    }
}
