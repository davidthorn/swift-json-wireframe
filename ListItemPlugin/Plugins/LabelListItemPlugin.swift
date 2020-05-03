//
//  LabelListItemPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

/// A delegate that the cell can used to inform its parent that it has been selected
public protocol LabelCellDelegate: AnyObject {

    /// The label cell has been selected
    func didSelect()
}

// MARK: - Label Cell Implementation -

final class LabelCell: UITableViewCell {

    // MARK: - Interal Properties -

    weak var delegate: LabelCellDelegate?

    // MARK: - Static Properties -

    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    // MARK: - Constructors -

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Common Init & Setup -

    func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewOnTouchInside))
        addGestureRecognizer(tap)
    }

    @objc func viewOnTouchInside() {
        delegate?.didSelect()
    }
}

// MARK: - Implementation -

public final class LabelListItemPluginImpl {

     // MARK: - Public Properties -

    public var id: String = UUID().uuidString
    public weak var delegate: ListItemPluginDelegate?
    public var type: ListItemType = .label
    public var name: String = "label"

    // MARK: - Private Properties -

    private(set) var item: LabelItem?

    // MARK: - Constructors -

    public init() { }

}

// MARK: - Extension - ListItem -

extension LabelListItemPluginImpl: LabelCellDelegate {

    public func cell(using tableview: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableview.dequeueReusableCell(
            withIdentifier: LabelCell.reuseIdentifier,
            for: indexPath
            ) as? LabelCell else {
                return nil
        }

        cell.textLabel?.text = item?.text
        if let disclosure = item?.disclosure, disclosure {
            cell.accessoryType = .disclosureIndicator
        }
        cell.delegate = self

        return cell
    }

    public func registerCell(tableview: UITableView) {
        tableview.register(LabelCell.self, forCellReuseIdentifier: LabelCell.reuseIdentifier)
    }

    public func didSelect() {
        delegate?.itemTapped(self)
    }

}

// MARK: - Extension - Model -

extension LabelListItemPluginImpl: ListItemPlugin {

    // MARK: - List Item Implementation -

    struct LabelItem: Codable {

         // MARK: - Public Properties -

        public let text: String
        public let multiline: Bool
        public let disclosure: Bool

        // MARK: - List Item Coding Keys -
        public enum CodingKeys: String, CodingKey, CaseIterable {
            case text
            case multiline
            case disclosure
        }

        // MARK: - List Item Decodable -

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            multiline = try container.decodeIfPresent(Bool.self, forKey: .multiline) ?? false
            disclosure = try container.decodeIfPresent(Bool.self, forKey: .disclosure) ?? false
        }

    }

    enum CodingKeys: CodingKey {
        case id
    }

    // MARK: - List Item Decodable -

    public func decode(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        item = try LabelItem(from: decoder)
    }

}
