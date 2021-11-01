//
//  UserListViewController.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import SnapKit
import UIKit

class UserListViewController: UIViewController {
    
    private let userCountToLoad: Int = 10
    
    private var isFirstFetchFromNetworkDone: Bool = false
    private var lastAddedCount: Int = 0
    private var isFetchInProgress: Bool = false
    private var isUsersShownOneTime: Bool = false
    
    // MARK: - Data
    
    var users: [User] = [] {
        didSet {
            self.reloadTableView(lastAddedCount: lastAddedCount)
        }
    }
    
    // MARK: - Views
    
    private lazy var usersTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .label
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableHeaderView = .init()
        tableView.estimatedRowHeight = UserTableViewCell.cellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addAction(.init(handler: { [weak self] action in
            self?.loadUsers(resetList: true)
        }), for: .valueChanged)
        return tableView
    }()
    
    
    // MARK: - Init

    override func loadView() {
        super.loadView()
        
        self.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUsers()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.title = "user_list_title".localized
        
        self.view.addSubview(usersTableView)
        
        usersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadUsers(resetList: Bool = false) {
        self.isFetchInProgress = true
        WebServices.loadUsers(count: self.userCountToLoad) { users, success in
            self.loadedUsers(resetList: resetList, users: users, success: success)
        }
    }
    
    private func loadedUsers(resetList: Bool, users: [User]?, success: Bool?) {
        self.usersTableView.refreshControl?.endRefreshing()
        if resetList {
            self.users = []
            self.isUsersShownOneTime = false
            self.isFirstFetchFromNetworkDone = false
            self.usersTableView.reloadData()
        }
        guard let users = users, success == true else {
            if self.isUsersShownOneTime {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.isFetchInProgress = false
                }
                
            } else {
                let savedUsers: [User] = self.getSavedUsers()
                self.addUsersToList(users: savedUsers)
                self.isFetchInProgress = false
            }
            return
        }
        
        if !self.isFirstFetchFromNetworkDone {
            CoreDataManager.deleteAllUsers()
            self.isFirstFetchFromNetworkDone = true
        }
        self.saveUsers(users: users)
        self.addUsersToList(users: users)
        self.isFetchInProgress = false
    }
    
    private func addUsersToList(users: [User]) {
        self.lastAddedCount = users.count
        self.users.append(contentsOf: users)
        self.isUsersShownOneTime = true
    }
    
    private func reloadTableView(lastAddedCount count: Int) {
        if self.users.isEmpty || self.users.count < count {
            self.usersTableView.reloadData()
            return
        }
        var indexPaths: [IndexPath] = []
        for i in (self.users.count - count) ..< self.users.count {
            indexPaths.append(.init(row: i, section: 0))
        }
        
        self.usersTableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    private func saveUsers(users: [User]) {
        users.forEach { user in
            CoreDataManager.addUser(user: user)
        }
    }
    
    private func getSavedUsers() -> [User] {
        let cdUsers: [CDUser] = CoreDataManager.getSavedUsers()
        return cdUsers.map { User(cdUser: $0) }
    }
    
    private func pushToDetails(index: Int) {
        let userDetailsVC: UserDetailsViewController = .init(user: self.users[index])
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}

// MARK: - UITableView dataSource & delegate
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        }
        
        cell.configure(with: self.users[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.pushToDetails(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isFetchInProgress && indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            loadUsers()
        }
    }
}
