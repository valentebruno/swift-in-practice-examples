// Swift in Practice — Edition #1: Welcome to Swift in Practice — First Topic: Bluetooth Low Energy (BLE) in Swift
// Section: 1) Central: Scan & Simple Discovery
// https://swiftinpractice.com/editions/1-bluetooth-low-energy-in-swift/#1-central-scan-simple-discovery

//swift//
import CoreBluetooth
import UIKit

class BLECentralController: NSObject {
    private var centralManager: CBCentralManager!
    private(set) var discoveredPeripherals: [CBPeripheral] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(
            delegate: self,
            queue: DispatchQueue(label: "ble.central.queue")
        )
    }

    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        // nil => all; you can filter with specific service UUIDs for efficiency
        centralManager.scanForPeripherals(
            withServices: nil,
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
        print("Scanning started")
    }

    func stopScan() {
        centralManager.stopScan()
        print("Scanning stopped")
    }
}

extension BLECentralController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth ON")
        default:
            print("Bluetooth unavailable: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
        print("Discovered: \(peripheral.name ?? "Unknown") rssi:\(RSSI)")
    }
}
