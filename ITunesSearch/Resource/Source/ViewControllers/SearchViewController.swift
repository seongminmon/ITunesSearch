//
//  SearchViewController.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "게임, 앱, 스토리 등"
//        $0.showsCancelButton = true
    }
    let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        $0.rowHeight = 100
    }
    
    let dummyData = PublishSubject<[ItunesItem]>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        
        // 네트워크 통신 test
        NetworkManager.shared.callRequest("kakaotalk")
            .subscribe(with: self) { owner, value in
                dump(value)
                owner.dummyData.onNext(value.results)
            } onError: { owner, error in
                if let error = error as? APIError, let description = error.errorDescription {
                    print(description)
                } else {
                    print("알 수 없는 에러")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        dummyData
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self
            )) { (row, element, cell) in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
