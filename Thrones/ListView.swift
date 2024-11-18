//
//  ListView.swift
//  Thrones
//
//  Created by Aimee Hong on 11/11/24.
//

import SwiftUI

struct ListView: View {
    @State private var houseVM = HouseViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(houseVM.houses) { house in
                    LazyVStack(alignment: .leading) {
                        Text(house.name)
                            .font(.title2)
                    }
                    .task {
                        await houseVM.loadNextIfNeeded(house: house)
                    }
                }
                .navigationTitle("Houses of Westeros")
                .listStyle(.plain)
                
                if houseVM.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .status) {
                Text("\(houseVM.houses.count) Houses Returned")
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button("Load All") {
                    Task {
                        await houseVM.loadAll()
                    }
                }
            }
        }
        .task {
            await houseVM.getData()
        }
    }
}

#Preview {
    ListView()
}
