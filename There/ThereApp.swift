//
//  ThereApp.swift
//  There
//
//  Created by Dena Sohrabi on 9/2/24.
//

import AppKit
import MenuBarExtraAccess
import SwiftUI

@main
struct ThereApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) var openWindow
    @ObservedObject var appState = AppState.shared
    @StateObject var router: Router = Router()
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(\.database, .shared)
                .frame(width: 360)
                .frame(minHeight: 380)
                .frame(maxHeight: 500)
                .padding(.top, 6)
                .background(Color(NSColor.windowBackgroundColor).opacity(0.78).ignoresSafeArea())
                .environmentObject(appState)
                .environmentObject(router)
        } label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                return $0
            }(NSImage(named: "appIcon")!)

            Image(nsImage: image)
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "hasCompletedInitialSetup") == false {
                        openWindow(id: "init")
                    } else {
                        appState.presentMenu()
                    }
                }
                .foregroundColor(.primary)
        }
        .menuBarExtraStyle(.window)
//        .menuBarExtraAccess(isPresented: $appState.menuBarViewIsPresented)
        .windowResizability(.contentSize)

        Window("There", id: "app") {
            ContentView()
                .environment(\.database, .shared)
                .frame(width: 350)
                .frame(minHeight: 200)
                .frame(maxHeight: 400)
                .background(TransparentBackgroundView().ignoresSafeArea())
                .environmentObject(appState)
                .environmentObject(router)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultPosition(.topLeading)
        .windowResizability(.contentSize)
        #if MAC_OS_VERSION_15_0
            .windowManagerRole(.principal)
            .windowLevel(.desktop)
        #endif
        Window("init", id: "init") {
            InitialView()
                .environment(\.database, .shared)
                .fixedSize()
                .frame(width: 600, height: 400)
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 600, height: 400)
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        #if MAC_OS_VERSION_15_0
            .windowBackgroundDragBehavior(.enabled)
        #endif

        Window("Add Timezone", id: "add-timezone") {
            AddTimezone()
                .environment(\.database, .shared)
                .frame(width: 500, height: 400)
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        #if MAC_OS_VERSION_15_0
            .windowLevel(.desktop)
            .windowManagerRole(.principal)
        #endif
            .defaultSize(width: 400, height: 400)
            .defaultPosition(.center)
            .windowResizability(.contentSize)
        #if MAC_OS_VERSION_15_0
            .windowBackgroundDragBehavior(.enabled)
        #endif

        Settings {
            Text("Coming soon...")
        }
        #if MAC_OS_VERSION_15_0
            .windowStyle(.plain)
        #endif
            .defaultSize(width: 600, height: 400)
            .windowResizability(.automatic)
    }
}

extension EnvironmentValues {
    @Entry var database: AppDatabase = .shared
}

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var menuBarViewIsPresented: Bool = false
    func presentMenu() {
        menuBarViewIsPresented = true
    }

    func hideMenu() {
        menuBarViewIsPresented = true
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//            AppState.shared.menuBarViewIsPresented = true
//        }
    }
}
