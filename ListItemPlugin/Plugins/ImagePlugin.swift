//
//  ImagePlugin.swift
//  ListItemPlugin
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Image Cell Implementation -

public class ImageCell: UITableViewCell {

    public static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    // MARK: - Interal Properties -

    let contentImageView = UIImageView()

    // MARK: - Constructors -

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Common Init & Setup -

    func commonInit() {
        contentView.addSubview(contentImageView)
        contentImageView.edgesToSuperview()
    }

    func setup(image: UIImage) {
        contentImageView.image = image
    }

}

// MARK: - Image Plugin Implementation -

public final class ImagePlugin {

    // MARK: - Public Properties -

    public weak var delegate: ListItemPluginDelegate?
    public var type: ListItemType = .custom
    public var name: String = "image"

    // MARK: - Private Properties -

    private(set) var loadedImage: UIImage?
    private(set) var pluginImage: Image?
    private(set) var error: ListItemPluginError?

    // MARK: - Private UI Elements -

    private(set) weak var cell: ImageCell?

    // MARK: - Constructors -

    public init() { }

}

// MARK: - Extension - TableView -

extension ImagePlugin {

    public func cell(using tableview: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableview.dequeueReusableCell(
            withIdentifier: ImageCell.reuseIdentifier,
            for: indexPath) as? ImageCell else {
                return nil
        }

        if let loadedImage = loadedImage {
            cell.contentImageView.image = loadedImage
        } else {
            do {
                try loadImage()
            } catch {
                debugPrint("error happened")
            }

        }

        return cell
    }

    public func registerCell(tableview: UITableView) {
        tableview.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentifier)
    }

}

// MARK: - Extension - ListItemPlugin -

public extension ImagePlugin {

    func isPlugin(name: String, type: ListItemType) -> Bool {
        self.name == name && self.type == type
    }

}

// MARK: - Extension - ImagePlugin -

extension ImagePlugin: ListItemPlugin {

    // MARK: - Image Plugin Model -

    struct Image: Codable {
        let source: URL

        enum CodingKeys: CodingKey {
            case source
        }
    }

    public func decode(with decoder: Decoder) throws {
        pluginImage = try Image(from: decoder)
    }

    public func getView() throws -> UIView {
        throw ListItemPluginError.unexpectedError
    }

}

// MARK: - Extension - Image Loading -

extension ImagePlugin {

    func loadImage() throws {

        guard let pluginImage = pluginImage else {
            throw ListItemPluginError.unexpectedError
        }

        URLSession.shared.dataTask(with: pluginImage.source) { [weak self] (imageData,_,_) in
            guard let data = imageData else  {
                self?.delegate?.throwError(error: .noImageData)
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let image = UIImage(data: data),
                    let plugin = self else {
                        self?.delegate?.throwError(error: .noImageData)
                        return
                }

                self?.loadedImage = image
                self?.delegate?.update(plugin)
            }
        }
        .resume()
    }

}

// MARK: - Extension - Array -

extension Array where Element == ImagePlugin.Type {

    public func plugin(with name: String, type: ListItemType) -> ImagePlugin? {
        let result = first(where: { $0.init().isPlugin(name: name, type: type) })?.init()
        return result
    }

}
