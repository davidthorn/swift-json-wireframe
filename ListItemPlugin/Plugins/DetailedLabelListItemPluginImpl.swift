//
//  DetailedLabelListItemPluginImpl.swift
//  ListItemPlugin
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Cell Implementation -

final class DetailedLabelCell: UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    // MARK: - Constructors -

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Common Init & Setup -

    func commonInit() { }

}

// MARK: - Implementation -

public final class DetailedLabelListItemPluginImpl {

     // MARK: - Public Properties -

    public var id: String = UUID().uuidString
    public weak var delegate: ListItemPluginDelegate?
    public var name: String = "detailedLabel"
    public var type: ListItemType = .detailedLabel

    // MARK: - Private Properties -

    private(set) var item: DetailedLabelItem?

    // MARK: - Constructors -

    public init() { }

}

// MARK: - Extension - ListItem -

extension DetailedLabelListItemPluginImpl {

    public func cell(using tableview: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableview.dequeueReusableCell(
            withIdentifier: DetailedLabelCell.reuseIdentifier,
            for: indexPath
            ) as? DetailedLabelCell else {
                return nil
        }

        cell.textLabel?.text = item?.title
        cell.detailTextLabel?.text = item?.subtitle
        
        if let disclosure = item?.disclosure, disclosure {
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }

    public func registerCell(tableview: UITableView) {
        tableview.register(DetailedLabelCell.self, forCellReuseIdentifier: DetailedLabelCell.reuseIdentifier)
    }

}

// MARK: - Extension - Plugin Model -

extension DetailedLabelListItemPluginImpl: ListItemPlugin {

    // MARK: - List Item Implementation -

    struct DetailedLabelItem: Codable {

        // MARK: - List Item Public Properties -

        public let title: String
        public let subtitle: String
        public let disclosure: Bool

        // MARK: - List Item Coding Keys -

        public enum CodingKeys: String, CodingKey, CaseIterable {
            case title
            case subtitle
            case disclosure
        }

    }

    enum CodingKeys: CodingKey {
        case id
    }

    // MARK: - List Item Decodable -

    public func decode(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        item = try DetailedLabelItem(from: decoder)
    }

}
