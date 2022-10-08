//
//  FunParticleApp.swift
//  FunParticle
//
//  Created by Alex Shipin on 10.09.2022.
//

import SwiftUI
import ParticlesSystem

@main
struct FunParticleApp: App {
    static let dependency = try! Dependency()

    var body: some Scene {
        WindowGroup {
            MainView(dependency: FunParticleApp.dependency)
        }
    }
}
