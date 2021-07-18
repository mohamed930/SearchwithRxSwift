//
//  UserViewModel.swift
//  SearchTableView
//
//  Created by Mohamed Ali on 18/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel {
    
    var isloadingBahaviour = BehaviorRelay<Bool>(value: false)
    var SearchTextFieldBahaviour = BehaviorRelay<String>(value: "")
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isSearchBehaviour : Observable<Bool> {
        return SearchTextFieldBahaviour.asObservable().map { search -> Bool in
            let isSearchEmpty = search.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isSearchEmpty
        }
    }
    
    var GettenData = BehaviorRelay<[UserModel]>(value: [])
    var FilteredGettenData = BehaviorRelay<[UserModel]>(value: [])
    var TempGettenData = BehaviorRelay<[UserModel]>(value: [])
    
    func GetData() {
        
        isloadingBahaviour.accept(true)

        let names = ["Mohamed Ali","Mohamed Mahmoud","Zyad Ali","C","L"]
        let status = ["Avaliable","Bussy","At Home","At Work","Avaliable"]
        
        var usersData = Array<UserModel>()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            
            for i in 0..<names.count {
                let ob = UserModel(UserName: names[i], UserStatus: status[i], UserImage: "Image")
                
                usersData.append(ob)
            }
            
            self.GettenData.accept(usersData)
            self.TempGettenData.accept(usersData)
            self.isloadingBahaviour.accept(false)
        }
        
        
        
    }
}
