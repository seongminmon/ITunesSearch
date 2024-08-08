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
    
    private let disposeBag = DisposeBag()
    private var itunesList = [ItunesItem]()
    
    
    struct Input {
        let searchText: ControlProperty<String?>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let itunesList: PublishSubject<[ItunesItem]>
        let startNetworking: PublishSubject<Void>
        let endNetworking: PublishSubject<Void>
        let failureNetworking: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let itunesList = PublishSubject<[ItunesItem]>()
        let startNetworking = PublishSubject<Void>()
        let endNetworking = PublishSubject<Void>()
        let failureNetworking = PublishSubject<String>()
        
        let query = input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
        
        query
            .subscribe(with: self, onNext: { owner, text in
                startNetworking.onNext(())
            })
            .disposed(by: disposeBag)
        
        query
            .flatMap { NetworkManager.shared.callRequest($0) }
            .subscribe(with: self) { owner, value in
                print("onNext")
                owner.itunesList = value.results
                itunesList.onNext(owner.itunesList)
                endNetworking.onNext(())
            } onError: { owner, error in
                print("onError")
                endNetworking.onNext(())
                
                var message = ""
                if let error = error as? APIError,
                    let description = error.errorDescription {
                    print(description)
                    message = description
                } else {
                    print("알 수 없는 에러")
                    message = "알 수 없는 에러"
                }
                failureNetworking.onNext(message)
            }
            .disposed(by: disposeBag)
        
        return Output(
            itunesList: itunesList,
            startNetworking: startNetworking,
            endNetworking: endNetworking,
            failureNetworking: failureNetworking
        )
    }
}
