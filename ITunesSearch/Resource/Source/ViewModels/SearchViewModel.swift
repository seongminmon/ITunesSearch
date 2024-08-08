//
//  SearchViewModel.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    var itunesList = [ItunesItem]()
    
    struct Input {
        let searchText: ControlProperty<String?>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let itunesList: PublishSubject<[ItunesItem]>
    }
    
    func transform(input: Input) -> Output {
        
        let itunesList = PublishSubject<[ItunesItem]>()
        
        input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .flatMap { NetworkManager.shared.callRequest($0) }
            .subscribe(with: self) { owner, value in
                owner.itunesList = value.results
                itunesList.onNext(owner.itunesList)
            } onError: { owner, error in
                print("onError: \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(
            itunesList: itunesList
        )
    }
}
