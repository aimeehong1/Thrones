//
//  HouseViewModel.swift
//  Thrones
//
//  Created by Aimee Hong on 11/11/24.
//

import Foundation

@Observable
class HouseViewModel {
    var houses: [House] = []
    var urlString = "https://www.anapioficeandfire.com/api/houses?page=1&pageSize=50"
    var isLoading = false
    var pageNumber = 1
    var pageSize = 50
    
    func getData() async {
        guard pageNumber != 0 else { return }
        isLoading = true
        urlString = "https://www.anapioficeandfire.com/api/houses?page=\(pageNumber)&pageSize=\(pageSize)"
        print("🕸️ We are accessing the URL \(urlString)")
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode the JSON into our local struct
            do {
                let newHouses = try JSONDecoder().decode([House].self, from: data)
                if newHouses.count < pageSize {
                    pageNumber = 0
                } else {
                    pageNumber += 1
                }
                houses = houses + newHouses
                isLoading = false
            } catch {
                print("😡 JSON ERROR: could not decode returned JSON data")
                isLoading = false
            }
        } catch {
            print("😡 ERROR: could not get data from \(urlString)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(house: House) async {
        guard let lastHouse = houses.last else { return }
        if house.id == lastHouse.id && pageNumber != 0 {
            await getData()
        }
    }
    
    func loadAll() async {
        guard pageNumber != 0 else { return }
        await getData() // get next page of data
        await loadAll() // will stop when all pages are retrieved
    }
}

