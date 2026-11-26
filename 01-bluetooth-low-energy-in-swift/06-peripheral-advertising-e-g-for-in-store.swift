// Swift in Practice — Edition #1: Welcome to Swift in Practice — First Topic: Bluetooth Low Energy (BLE) in Swift
// Section: 3) Peripheral (Advertising) — E.g., for In-Store Promotions or Beacons
// https://swiftinpractice.com/editions/1-bluetooth-low-energy-in-swift/#3-peripheral-advertising-e-g-for-in-store-promotions-or-beac

//swift//
import CoreBluetooth

class BLEPeripheralController: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!

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

        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read],
            value: Data("Exhibit 42".utf8),
            permissions: [.readable]
        )

        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        guard error == nil, peripheral.state == .poweredOn else { return }
        peripheral.startAdvertising([
            CBAdvertisementDataLocalNameKey: "MuseumExhibit",
            CBAdvertisementDataServiceUUIDsKey: [service.uuid]
        ])
    }
}
