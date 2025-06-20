//
//  UserData.swift
//  Lab 8 t1
//
//  Created by Елизавета Сенюк on 19.06.25.
//

import Foundation
struct BankAccount: Codable {
    let name: String
    let balance: Double
}
struct UserData: Codable {
    let login: String
    let email: String
    let password: String
    var bankAccounts: [BankAccount]

    private static let filename = "User.plist"

    func saveToPlist() {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UserData.filename) {
            do {
                let data = try PropertyListEncoder().encode(self)
                try data.write(to: url)
            } catch {
                print("Ошибка сохранения пользователя: \(error)")
            }
        }
    }

    static func loadFromPlist() -> UserData? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UserData.filename) {
            do {
                let data = try Data(contentsOf: url)
                let user = try PropertyListDecoder().decode(UserData.self, from: data)
                return user
            } catch {
                print("Ошибка загрузки пользователя: \(error)")
            }
        }
        return nil
    }
}
