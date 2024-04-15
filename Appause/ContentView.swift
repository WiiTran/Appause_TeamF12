//
//  ContentView.swift
//  Appause
//
//  Created by Dakshina Ethdath Waduge on 04/15/24.
//

import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject{
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unnamed Device")
        }
    }
}



struct ContentView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in Text(peripheral)
            }
            .navigationTitle("Peripherals")
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
