//
//  ModelData.swift
//  MandArt
//
//  Created by Denise Case on 11/27/22.
//

import Foundation

class ModelData : ObservableObject {
    static var shared = ModelData()
    
    func load<T:Decodable>(_ fn:String) -> T {
        let data: Data
        guard let file = Bundle.main.url(forResource: fn, withExtension: nil)
        else {
            fatalError("Couldn't find \(fn) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf:file)
        } catch {
            fatalError("Couldn't load \(fn) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self,from:data)
        } catch {
            fatalError("Couldn't parse \(fn) as \(T.self):\n\(error)")
        }
    }
    
}
