//
//  SwiftUIView.swift
//  Project190
//
// Created by Alec Lobato
//

/* Commented by Vlad Puriy
 The EULAView and LoginView classes both have a @Binding var showNextView: DisplayState property. This binding is passed from the ContentView, allowing the EULAView and LoginView to update the displayState based on user interactions.

 In the EULAView, the showNextView binding is used to update the displayState when the user accepts the EULA. When the user clicks the "Accept" button, the displayState is set to .login, triggering a transition to the LoginView.

 In the LoginView, the showNextView binding is used to update the displayState when the user successfully logs in. When the user clicks the "Login" button and their login is successful, the displayState is set to .mainTeacher, triggering a transition to the MainTeacherView.
 */

import SwiftUI



struct EULAView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    var body: some View {
        VStack {
            Text("EULA")
                .padding(.top, 15)
                .background(Color.white)
                .foregroundColor(.black)
            
            GeometryReader { geometry in
                ScrollView {
                    Text("""
                         \nIMPORTANT - PLEASE READ CAREFULLY BEFORE CONTINUING:
                         \nVersion: 1.0 (September 9th, 2023)\n
                         \nThis End-User License Agreement (EULA) is a legal agreement between you (either an individual or a single entity) and MacroSoft for Appause identified above, which includes computer software and associated media and printed materials, as well as any \"online\" or electronic documentation (\"Appause\").
                          \nBy installing, copying, or otherwise using the Appause, you agree to be bound by the terms of this EULA. If you do not agree to the terms of this EULA, do not install or use Appause.
                         \nLICENSE GRANT: MacroSoft grants you a non-exclusive, non-transferable license to use the Appause for your personal or commercial use in accordance with this EULA. No fees will be imposed upon the individual for the usage of Appause.
                        \nRESTRICTIONS: You may not reverse engineer, decompile, or disassemble the Appause, except to the extent that such activity is expressly permitted by applicable law. You may not rent, lease, or lend the Appause. You may not use the Appause to engage in any illegal or unauthorized activity. MacroSoft will not be held responsible for the actions of the individual should they be discovered to be using Appause for illicit activity.
                         \nPRIVACY POLICY: The Appause uses Bluetooth functionality to communicate with other devices. By using the Appause, you acknowledge and agree that your device's Bluetooth functionality will be used to establish connections with other devices, and that data will be transmitted between devices over Bluetooth. You further acknowledge and agree that MacroSoft may collect and use data from your device as described in the [PRIVACY POLICY], which is incorporated by reference into this EULA.
                         \nMacrosoft may collect and store personal information for the sole usage of Appause. This information is not limited to, the end user's device applications, blocking or allowing communications (phone calls, text messages, notifications, etc..), etc.. By downloading Appause, you grant Appause permission to access and regulate your device for the duration of a session. Once a session is completed and the end user logs out, Appause will no longer control any aspects of the target device. MacroSoft will not be held responsible for any malicious attacks with the usage of Appause. This is not limited to, breaches, malware, phishing, denial of service (DOS), distrubuted denial of service (DDOS), email spoofing, cryptojacking, etc..
                         \nDISCLAIMER OF WARRANTY AND CUSTOMER SERVICE: The Appause is provided \"as is\" without warranty of any kind, either express or implied, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose. MacroSoft does not warrant that the Appause will meet your requirements or that the operation of the Appause will be uninterrupted or error-free. MacroSoft will not provide any sort of customer service beyond the deployment of Appause as of December 16, 2023. The End User may seek the assistance of a 3rd Party for the sole purpose of correcting any user-breaking errors.
                         \nLIMITATION OF LIABILITY: In no event shall MacroSoft, its affiliates, officers, directors, employees, agents, or suppliers be liable for any direct, indirect, incidental, special, or consequential damages, including, but not limited to, damages for loss of profits, revenue, data, or use, incurred by you or any third party, whether in an action in contract or tort, even if MacroSoft has been advised of the possibility of such damages. This limitation of liability applies to all claims, whether based on warranty, contract, tort, or any other legal theory, and whether or not the possibility of such damages was foreseeable. Some jurisdictions do not allow the exclusion or limitation of liability for incidental or consequential damages, so the above limitation may not apply to you. In such jurisdictions, MacroSoft's liability shall be limited to the fullest extent permitted by law. This limitation of liability is an essential part of this EULA, and you acknowledge that MacroSoft would not grant you the license to use the Appause without it.
                         \nTERM AND TERMINATION: This EULA is effective until terminated. You may terminate this EULA at any time by uninstalling or destroying all copies of the Appause. MacroSoft may terminate this EULA if you breach any of the terms and conditions of this EULA and will do so if necessary. Upon termination, you must immediately uninstall or destroy all copies of the Appause. Failure to do so will result in a breach of the EULA for Appause and MacroSoft will not be held responsible for any illict actions as highlighted in [LIMITATION OF LIABILITY]
                         \nSOFTWARE ACTIVATION AND FEES: MacroSoft is not responsible for any fees incurred with data costs whilst using Appause on behalf of the End User. Appause is a free application and has no fees associated with it.
                         \nUPDATES AND MAINTENANCE: MacroSoft will not be held responsible for updating Appause after December 16, 2023. Should Appause suffer a fatal error, the end user is responsible for finding a team, company, or corporation to correct the issue. Macrosoft will not assist in any regard and is not responsible for any damages caused by a 3rd party. See [DISCLAIMER OF WARRANTY AND CUSTOMER SERVICE] and [PRIVACY POLICY] for additional details.
                         \nAUDITING RIGHTS AND USER SECURITY: MacroSoft, with a primary focus on safeguarding End Users and ensuring the utmost integrity of the Appause software, hereby asserts the right to conduct audits on Appause without the requirement of prior notification. These audits are conducted exclusively in the pursuit of bolstering user security and mitigating potential threats. It is imperative to acknowledge that user data retained by Appause is subject to stringent encryption protocols. These encryption policies may undergo evolution over time in response to emerging security standards and threats. However, it is emphasized that, irrespective of policy alterations, user data will consistently be upheld under the strictest security measures. As stated in the [PRIVACY POLICY], MacroSoft will not be responsible for loss of data as a result of malicious attacks. 
                         \nGOVERNING LAW: This EULA shall be governed by and construed in accordance with the laws of the United States, without giving effect to any principles of conflicts of law.
                         \nENTIRE AGREEMENT: This EULA constitutes the entire agreement between you and MacroSoft with respect to the Appause and supersedes all prior or contemporaneous communications and proposals, whether oral or written, between you and MacroSoft with respect to the Appause.
                         \nBy installing and using the Appause, you acknowledge that you have read this EULA, understand it, and agree to be bound by its terms and conditions. If you do not agree to the terms and conditions of this EULA, do not install or use Appause. MacroSoft reserves the right to change any sections of this EULA at their discretion and without prior notification to the end user.
""")
                    
                                            .padding(.top, 30)
                                            .padding(.horizontal, 50)
                                                .background(Color.white)
                                                .foregroundColor(.black)
                                                .lineLimit(nil)
                                                .frame(
                                                    minWidth: 100,
                                                    maxWidth: geometry.size.width,
                                                    minHeight: geometry.size.height,
                                                    maxHeight: .infinity,
                                                    alignment: .topLeading)
                                    }
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                                        showNextView = .login}
                                }) {
                                    Text("Accept")
                                        .padding()
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                .padding(.bottom, 100)
                            }
                        }
                    }

                   
struct EULAView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .eula

    static var previews: some View {
        EULAView(showNextView: $showNextView)
    }
}
