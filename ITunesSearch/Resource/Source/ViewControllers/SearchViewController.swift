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
        // TODO: - editing 중 cancelButton 보이기
//        $0.showsCancelButton = true
    }
    let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        $0.rowHeight = 100
    }
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text,
            searchButtonTap: searchBar.rx.searchButtonClicked
        )
        let output = viewModel.transform(input: input)
        
        output.itunesList
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
