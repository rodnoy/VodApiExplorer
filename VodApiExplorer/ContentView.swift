//
//  ContentView.swift
//  VodApiExplorer
//
//  Created by KIRILL SIMAGIN on 28/03/2024.
//

import SwiftUI
import Observation
import VodClient

struct ContentView: View {
    @Bindable var vm = ViewModel()
    var body: some View {
        VStack {
            switch vm.fetchPhase {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView("Requesting to AI")
            case .success(let text):
                    Text(text)
                    .foregroundStyle(Color.green)
            case .failure(let error):
                Text(error)
                    .foregroundStyle(Color.red)
            }
            Button("get Catalog") {
                Task { await vm.getCatalog() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.fetchPhase == .loading)
            
        }
        .padding()
        .navigationTitle("Vod API Explorer")
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    @Observable
    class ViewModel {
        let categoriesClient = VodClient()
        var fetchPhase = FetchPhase.initial
        
        @MainActor
        func getCatalog() async {
            self.fetchPhase = .loading
            do {
                let text = try await categoriesClient.getAllCategories()
                self.fetchPhase = .success(text)
            }
            catch {
                print(error.localizedDescription)
                // error in CategoryDTO
                self.fetchPhase = .failure(error.localizedDescription)
            }
        }
    }
}
enum FetchPhase: Equatable {
    case initial
    case loading
    case success(String)
    case failure(String)
}
