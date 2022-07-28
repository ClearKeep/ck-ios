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
	var getClientInGroup: [GroupDetailClientViewModel]? { get }
	var searchUser: [GroupDetailUserViewModels]? { get }
	var groupBase: GroupDetailBaseViewModel? { get }
	var getProfile: GroupDetailUserViewModels? { get }
	var myProfile: GroupDetailProfileViewModel? { get }
	var profileWithLink: GroupDetailUserViewModels? { get }
	var searchUserWithEmail: [GroupDetailUserViewModels]? { get }
	var removeMember: [GroupDetailClientViewModel]? { get }
	var leaveGroup: GroupDetailBaseViewModel? { get }
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
	var getClientInGroup: [GroupDetailClientViewModel]?
	var searchUser: [GroupDetailUserViewModels]?
	var groupBase: GroupDetailBaseViewModel?
	var getProfile: GroupDetailUserViewModels?
	var myProfile: GroupDetailProfileViewModel?
	var profileWithLink: GroupDetailUserViewModels?
	var searchUserWithEmail: [GroupDetailUserViewModels]?
	var removeMember: [GroupDetailClientViewModel]?
	var leaveGroup: GroupDetailBaseViewModel?
}

extension GroupDetailViewModels {

	init(groups: IGroupDetailModels) {
		let group = groups.groupModel.map { member in
			GroupDetailViewModel(member)
		}
		self.init(getGroup: group)
	}

	init(clients: IGroupDetailModels) {
		let client = clients.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		self.init(getClientInGroup: client)
	}

	init(users: IGroupDetailModels) {
		let searchUsers = users.searchUser?.lstUser.map { member in
			GroupDetailUserViewModels(user: member)
		}
		self.init(searchUser: searchUsers)
	}

	init(error: IGroupDetailModels) {
		let errorGroup = error.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(profile: IGroupDetailModels) {
		let user = profile.getProfile.map { member in
			GroupDetailUserViewModels(profile: member)
		}
		self.init(getProfile: user)
	}

	init(myprofile: IGroupDetailModels) {
		let user = myprofile.getProfile.map { member in
			GroupDetailProfileViewModel(member)
		}
		self.init(myProfile: user)
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
			GroupDetailClientViewModel(member)
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
