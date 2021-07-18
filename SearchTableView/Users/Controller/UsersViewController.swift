//
//  ViewController.swift
//  SearchTableView
//
//  Created by Mohamed Ali on 18/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!

    let userviewmodel = UserViewModel()
    let disposebag = DisposeBag()
    
    var action = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSearchBehaviour()
        ResposnseSearchEmpty()
        isloadingBehaviour()
        ResponseTableView()
        userviewmodel.GetData()
        SubscribeToChooceTheCell()
    }
    
    func UserSearchBehaviour() {
        
        SearchBar.rx.text.orEmpty.bind(to: userviewmodel.SearchTextFieldBahaviour).disposed(by: disposebag)
        
        let queryResult = SearchBar.rx.text.orEmpty
           .throttle(.microseconds(300), scheduler: MainScheduler.instance)
           .distinctUntilChanged()
           .map ({ query in
               self.userviewmodel.GettenData.value.filter { user in
                   query.isEmpty || user.UserName.lowercased().contains(query.lowercased())
               }
           })

           queryResult.asObservable().subscribe(onNext: { [weak self] usermodel in
            
               guard let self = self else { return }
            
            self.userviewmodel.GettenData.accept(usermodel)
           }).disposed(by: disposebag)
         
    }
    
    func ResposnseSearchEmpty() {
        
        userviewmodel.isSearchBehaviour.asObservable().subscribe(onNext: { [weak self] action in
            
            guard let self = self else { return }
            
            if action {
                print("TextField is Empty")
                self.userviewmodel.GettenData.accept(self.userviewmodel.TempGettenData.value)
                self.loadingLabel.isHidden = true
                self.tableView.isHidden = false
            }
            else {
                if self.userviewmodel.GettenData.value.isEmpty {
                    self.loadingLabel.text = "No Users"
                    self.loadingLabel.isHidden = false
                    self.tableView.isHidden = true
                }
            }
            
        }).disposed(by: disposebag)
        
    }
    
    func isloadingBehaviour() {
        
        userviewmodel.isloadingBahaviour.subscribe(onNext: { [weak self] load in
            
            guard let self = self else { return }
            
            if load {
                self.tableView.isHidden = true
                self.loadingLabel.isHidden = false
            }
            else {
                self.tableView.isHidden = false
                self.loadingLabel.isHidden = true
            }
            
        }).disposed(by: disposebag)
        
    }
    
    func ResponseTableView() {
        
        userviewmodel.GettenData
                .bind(to: self.tableView
                    .rx
                    .items(cellIdentifier: "Cell",
                           cellType: Cell.self)) { row, branch, cell in
                    cell.ConfigureCell(branch)
            }
            .disposed(by: disposebag)
        
    }
    
    // MARK:- TODO:- This Method For Going to The UserDetails To Start A Chat.
    func SubscribeToChooceTheCell () {
       
       Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(UserModel.self))
           .bind { selectedIndex, branch in

               print(selectedIndex[1], branch.UserName)
       }
       .disposed(by: disposebag)
       
   }
   // ------------------------------------------------

}

