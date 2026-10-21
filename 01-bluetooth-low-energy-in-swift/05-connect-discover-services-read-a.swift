// Swift in Practice — Edition #1: Welcome to Swift in Practice — First Topic: Bluetooth Low Energy (BLE) in Swift
// Section: 2) Connect, Discover Services & Read a Characteristic
// https://swiftinpractice.pages.dev/editions/1-bluetooth-low-energy-in-swift/#2-connect-discover-services-read-a-characteristic

//swift//

extension BLECentralController: CBPeripheralDelegate {
    func connect(to peripheral: CBPeripheral) {
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager,
                       didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "device")")
        // Pass nil or specific service UUIDs
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral,
                   didDiscoverServices error: Error?) {
        guard error == nil else { return }
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                   didDiscoverCharacteristicsFor service: CBService,
                   error: Error?) {
        for char in service.characteristics ?? [] {
            // Example: read if readable
            if char.properties.contains(.read) {
                peripheral.readValue(for: char)
            }
            // Subscribe to notifications if needed
            if char.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: char)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                   didUpdateValueFor characteristic: CBCharacteristic,
                   error: Error?) {
        guard let data = characteristic.value else { return }
        // Parse data according to the device spec
        print("Characteristic \(characteristic.uuid) value: \(data as NSData)")
    }
}
