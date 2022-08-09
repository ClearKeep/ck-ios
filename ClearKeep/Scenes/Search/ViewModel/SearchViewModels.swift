//
//  SearchViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//
import Foundation
import Networking
import ChatSecure
import Model

protocol ISearchViewModels {
	var groupViewModel: ISearchGroupViewModels? { get }
	var userViewModel: ISearchUserViewModels? { get }

}

struct SearchViewModels: ISearchViewModels {
	var groupViewModel: ISearchGroupViewModels?
	var userViewModel: ISearchUserViewModels?
}

extension SearchViewModels {

	init(responseGroup: ISearchModels, responseUser: ISearchModels) {
		self.groupViewModel = SearchGroupViewModels(responseGroup, responseUser: responseUser)
		self.userViewModel = SearchUserViewModels(responseUser)
	}
}
