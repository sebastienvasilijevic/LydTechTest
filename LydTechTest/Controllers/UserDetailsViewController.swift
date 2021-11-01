//
//  UserDetailsViewController.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 01/11/2021.
//

import SnapKit
import UIKit

class UserDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var user: User! {
        didSet {
            self.title = user.getFullName(showTitle: false)
        }
    }
    
    private var tableRows: [UserDetailRow] = []
    
    
    // MARK: - Views
    
    private lazy var userTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        return tableView
    }()
    
    
    // MARK: Init
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        
        self.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillTableRows()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(userTableView)
        
        userTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    // MARK: - Methods
    
    private func fillTableRows() {
        guard let user = self.user else {
            return
        }
        
        tableRows = [
            .init(rowType: .image, value: user.picture),
            .init(rowType: .text, value: user.getFlagNameAge(showTitle: true, showAge: false)),
            .init(rowType: .details, value: ["user_details_dateOfBirth".localized, user.dob.getDateWithAge(format: Constants.DateFormat.french)]),
            .init(rowType: .details, value: ["user_details_registrationDate".localized, user.registered.getDateWithAge(format: Constants.DateFormat.french)]),
            .init(rowType: .details, value: ["user_details_email".localized, user.email]),
            .init(rowType: .details, value: ["user_details_phone".localized, user.phone]),
            .init(rowType: .details, value: ["user_details_cell".localized, user.cell]),
            .init(rowType: .details, value: ["user_details_address".localized, user.location.getFullAddress()]),
            .init(rowType: .map, value: ["title": user.location.getFullAddress(), "lat": user.location.latitude, "lon": user.location.longitude])
        ]
        
        self.userTableView.reloadData()
    }
}

// MARK: - UITableView dataSource & delegate
extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableRow: UserDetailRow = tableRows[indexPath.row]
        
        switch tableRow.rowType {
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell,
               let imageUri = tableRow.value as? String {
                cell.configure(imageUri: imageUri)
                return cell
            }
        case .text:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell,
               let text = tableRow.value as? String {
                cell.configure(text: text)
                return cell
            }
        case .details:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell,
               let value = tableRow.value as? [String], value.count == 2 {
                let text: String = value[0]
                let detail: String = value[1]
                cell.configure(text: text, detail: detail)
                return cell
            }
        case .map:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as? MapTableViewCell,
               let dictionary = tableRow.value as? [String: String],
               let address = dictionary["title"],
               let latitude = dictionary["lat"],
               let longitude = dictionary["lon"] {
                cell.configure(address: address, latitude: latitude, longitude: longitude)
                return cell
            }
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableRow: UserDetailRow = tableRows[indexPath.row]
        
        switch tableRow.rowType {
        case .image:
            return ImageTableViewCell.cellHeight
        case .map:
            return MapTableViewCell.cellHeight
        default:
            break
        }
        
        return UITableView.automaticDimension
    }
}
