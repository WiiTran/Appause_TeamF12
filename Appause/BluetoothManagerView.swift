//
//  BluetoothManagerView.swift
//  Appause
//
//  Created by Dash on 9/25/24
//

import SwiftUI
import MultipeerConnectivity

struct DiscoveredPeer: Identifiable {
    let id = UUID()
    let peerID: MCPeerID
}

struct BluetoothManagerView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var isBrowsing = false
    @State private var showDisconnectPopup = false
    @State private var selectedPeer: DiscoveredPeer?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 16) {
                Spacer().frame(height: 75)
                
                Text("Nearby Devices")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                // Search/Stop Button
                Button(action: {
                    if isBrowsing {
                        bluetoothManager.stopBrowsing()
                    } else {
                        bluetoothManager.startBrowsing()
                    }
                    isBrowsing.toggle()
                }) {
                    Text(isBrowsing ? "Stop Searching" : "Search")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                
                // Discovered Devices List
                List {
                    Section(header: Text("Discovered Devices")) {
                        ForEach(bluetoothManager.discoveredPeers) { peer in
                            HStack {
                                Text(peer.peerID.displayName)
                                    .font(.headline)
                                Spacer()
                                
                                if bluetoothManager.connectedPeers.contains(peer.peerID) {
                                    Text("Connected")
                                        .foregroundColor(.green)
                                } else {
                                    Button("Connect") {
                                        bluetoothManager.connectToPeer(peer.peerID)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Connected Devices")) {
                        ForEach(bluetoothManager.connectedPeers, id: \.self) { peer in
                            HStack {
                                Text(peer.displayName)
                                    .font(.headline)
                                Spacer()
                                
                                Button("Disconnect") {
                                    selectedPeer = DiscoveredPeer(peerID: peer)
                                    showDisconnectPopup = true
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            // Disconnect Confirmation Popup
            if showDisconnectPopup {
                VStack(spacing: 20) {
                    Text("Disconnect Device")
                        .font(.title)
                        .padding()
                    
                    Text("Are you sure you want to disconnect from \(selectedPeer?.peerID.displayName ?? "this device")?")
                    
                    HStack {
                        Button("Disconnect") {
                            if let peer = selectedPeer?.peerID {
                                bluetoothManager.disconnectPeer(peer)
                            }
                            withAnimation {
                                showDisconnectPopup = false
                            }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("Cancel") {
                            withAnimation {
                                showDisconnectPopup = false
                            }
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.move(edge: .bottom))
                .offset(y: showDisconnectPopup ? 0 : UIScreen.main.bounds.height)
                .animation(.easeInOut(duration: 0.5), value: showDisconnectPopup)
            }
            
            // "Menu" Button
            Button(action: {
                // Menu action
            }) {
                Text("Menu")
                    .font(.headline)
                    .padding(16)
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .background(Color.clear)
            .cornerRadius(20)
            .padding([.leading, .top], 16)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DeviceDisconnected"))) { _ in
            print("A device has been disconnected.")
        }
    }
}

// BluetoothManager class
class BluetoothManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    @Published var discoveredPeers: [DiscoveredPeer] = []
    @Published var connectedPeers: [MCPeerID] = []
    private var peerID: MCPeerID!
    private var mcSession: MCSession!
    private var mcBrowser: MCNearbyServiceBrowser!
    private var mcAdvertiser: MCNearbyServiceAdvertiser!
    private let serviceType = "admin-control"
    
    override init() {
        super.init()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        mcBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        mcBrowser.delegate = self
        
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        mcAdvertiser.delegate = self
        mcAdvertiser.startAdvertisingPeer()
    }
    
    // Start browsing for peers
    func startBrowsing() {
        mcBrowser.startBrowsingForPeers()
    }
    
    // Stop browsing for peers
    func stopBrowsing() {
        mcBrowser.stopBrowsingForPeers()
    }
    
    // Connect to a peer
    func connectToPeer(_ peer: MCPeerID) {
        mcBrowser.invitePeer(peer, to: mcSession, withContext: nil, timeout: 10)
    }
    
    // Disconnect from a peer
    func disconnectPeer(_ peer: MCPeerID) {
        if let index = connectedPeers.firstIndex(of: peer) {
            connectedPeers.remove(at: index)
            mcSession.cancelConnectPeer(peer)
            NotificationCenter.default.post(name: NSNotification.Name("DeviceDisconnected"), object: nil)
        }
    }
    
    // MARK: - MCSessionDelegate Methods
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                    self.discoveredPeers.removeAll { $0.peerID == peerID }
                }
            case .notConnected:
                if let index = self.connectedPeers.firstIndex(of: peerID) {
                    self.connectedPeers.remove(at: index)
                    NotificationCenter.default.post(name: NSNotification.Name("DeviceDisconnected"), object: nil)
                }
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            let newPeer = DiscoveredPeer(peerID: peerID)
            if !self.discoveredPeers.contains(where: { $0.peerID == peerID }) {
                self.discoveredPeers.append(newPeer)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll { $0.peerID == peerID }
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            invitationHandler(true, mcSession)
        }
    
    // Empty implementations for other delegate methods
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

struct BluetoothManagerView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothManagerView()
    }
}
