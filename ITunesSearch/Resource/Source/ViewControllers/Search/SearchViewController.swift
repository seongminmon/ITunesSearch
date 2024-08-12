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
    
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "게임, 앱, 스토리 등"
    }
    
    private let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        $0.rowHeight = 100
    }
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            searchText: searchController.searchBar.rx.text,
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked
        )
        let output = viewModel.transform(input: input)
        
        output.itunesList
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self
            )) { (row, element, cell) in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
        
        output.startNetworking
            .bind(with: self) { owner, _ in
                owner.showLoadingToast()
            }
            .disposed(by: disposeBag)
        
        output.endNetworking
            .bind(with: self) { owner, _ in
                DispatchQueue.main.async {
                    owner.hideToast()
                }
            }
            .disposed(by: disposeBag)
        
        output.failureNetworking
            .bind(with: self) { owner, value in
                DispatchQueue.main.async {
                    owner.showFailureToast(value)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ItunesItem.self)
            .subscribe(with: self) { owner, value in
                let vc = SearchDetailViewController(data: value)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
