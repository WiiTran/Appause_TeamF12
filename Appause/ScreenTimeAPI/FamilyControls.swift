//
//  FamilyControls.swift
//  Appause
//
//  Created by Luke Simoni on 4/7/24.
//

import FamilyControls


func authIndividual() async {
    do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual);
    } catch {
        //catch error if not approved
        print("u suck");
    }
}
