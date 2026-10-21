// Swift in Practice — Edition #1: Welcome to Swift in Practice — First Topic: Bluetooth Low Energy (BLE) in Swift
// Section: 3) Peripheral (Advertising) — E.g., for In-Store Promotions or Beacons
// https://swiftinpractice.pages.dev/editions/1-bluetooth-low-energy-in-swift/#3-peripheral-advertising-e-g-for-in-store-promotions-or-beac

//swift//
import CoreBluetooth

class BLEPeripheralController: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    private var transferCharacteristic: CBMutableCharacteristic!

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            setupServiceAndAdvertise()
        }
    }

    private func setupServiceAndAdvertise() {
        let serviceUUID = CBUUID(string: "1234")
        let characteristicUUID = CBUUID(string: "ABCD")

        transferCharacteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read, .write],
            value: nil,
            permissions: [.readable, .writeable]
        )

        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [transferCharacteristic]
        peripheralManager.add(service)

        // Advertise with a local name and service UUIDs
        peripheralManager.startAdvertising([
            CBAdvertisementDataLocalNameKey: "PromoBeacon",
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ])
    }
}
