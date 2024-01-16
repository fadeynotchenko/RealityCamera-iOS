//
//  FirebaseHelper.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class FirebaseHelper {

    static func asyncDownloadToFileSystem(path: String, resultHandler: @escaping (URL) -> (), progressHandler: @escaping (Double) -> () = { _ in }) -> StorageDownloadTask? {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docURL.appendingPathComponent(path)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            resultHandler(fileURL)
            
            return nil
        }
        
        let ref = Storage.storage().reference(withPath: path)
        
        let task = ref.write(toFile: fileURL) { url, error in
            guard let localURL = url else {
                print("Ошибка загрузки файла")
                
                return
            }
            
            resultHandler(localURL)
        }
        
        let _ = task.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            
            progressHandler(percentComplete)
        }
        
        return task
    }
    
    static func incrementLoads(by name: String) {
        Firestore.firestore().collection("Models").document(name).updateData(["loads": FieldValue.increment(Int64(1))])
    }
    
    
    static func fetchData(completion: @escaping ([USDZ3DModel]) -> ()) {
        Firestore.firestore().collection("Models").order(by: "loads", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let models = documents.compactMap { documentSnapshot -> USDZ3DModel? in
                let data = documentSnapshot.data()
                let name = documentSnapshot.documentID
                
                let isAnimation = data["isAnimation"] as? Bool ?? false
                let isPremium = data["prem"] as? Bool ?? false
                let loads = data["loads"] as? Int ?? 0
                let category = ModelCategory(rawValue: data["category"] as? String ?? "") ?? .memes
                
                return USDZ3DModel(name: name, isAnimation: isAnimation, isPremium: isPremium, category: category, loads: loads)
            }
            
            completion(models)
        }
    }
}
