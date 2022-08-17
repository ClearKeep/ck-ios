//
//  GroupDetailViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//
import Foundation
import Model

protocol IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel? { get }
	var getClientInGroup: [GroupDetailProfileViewModel]? { get }
	var searchUser: [GroupDetailUserViewModels]? { get }
	var groupBase: GroupDetailBaseViewModel? { get }
	var getProfile: GroupDetailUserViewModels? { get }
	var myProfile: GroupDetailProfileViewModel? { get }
	var profileWithLink: GroupDetailUserViewModels? { get }
	var searchUserWithEmail: [GroupDetailUserViewModels]? { get }
	var statusMember: [GroupDetailProfileViewModel]? { get }
	var removeMember: [GroupDetailClientViewModel]? { get }
	var leaveGroup: GroupDetailBaseViewModel? { get }
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
	var getClientInGroup: [GroupDetailProfileViewModel]?
	var searchUser: [GroupDetailUserViewModels]?
	var groupBase: GroupDetailBaseViewModel?
	var getProfile: GroupDetailUserViewModels?
	var myProfile: GroupDetailProfileViewModel?
	var profileWithLink: GroupDetailUserViewModels?
	var searchUserWithEmail: [GroupDetailUserViewModels]?
	var statusMember: [GroupDetailProfileViewModel]?
	var removeMember: [GroupDetailClientViewModel]?
	var leaveGroup: GroupDetailBaseViewModel?
}

extension GroupDetailViewModels {

	init(avatar: IGroupDetailModels, clients: IGroupDetailModels) {
		let group = clients.groupModel.map { member in
			GroupDetailViewModel(member)
		}

		var lst: [GroupDetailProfileViewModel] = []
		avatar.members?.forEach { client in
			lst.append(GroupDetailProfileViewModel(user: client))
		}
		self.init(getGroup: group, getClientInGroup: lst)
	}

	init(users: [GroupDetailUserViewModels]) {
		self.init(searchUser: users)
	}

	init(error: IGroupDetailModels) {
		let errorGroup = error.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(profileInforWithLink: IGroupDetailModels) {
		self.profileWithLink = GroupDetailUserViewModels.init(user: profileInforWithLink.getProfileModelWithLink)
	}

	init(usersWithEmail: IGroupDetailModels) {
		let searchUsers = usersWithEmail.searchUserModelWithEmail?.lstUser.map { member in
			GroupDetailUserViewModels(user: member)
		}
		self.searchUserWithEmail = searchUsers
	}

	init(removeClient: IGroupDetailModels) {
		let errorGroup = removeClient.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(members: IGroupDetailModels) {
		let client = members.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member: member)
		}
		self.init(removeMember: client)

	}

	init(leaveGroup: IGroupDetailModels) {
		let errorGroup = leaveGroup.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(leaveGroup: errorGroup)
	}
}
