import UIKit

final class CalendarGridLayout: UICollectionViewLayout {

    // MARK: - Configurable sizes
    private let timeColumnWidth: CGFloat = 70
    private let headerHeight: CGFloat = 60
    private let cellWidth: CGFloat = 160
    private let cellHeight: CGFloat = 80

    // MARK: - Spacing
    private let cellSpacing: CGFloat = 8              // space between booking cells
    private let headerBottomSpacing: CGFloat = 12     // space between date header & bookings
    private let timeColumnRightSpacing: CGFloat = 12  // space between time & bookings

    // MARK: - Internal
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero

    // MARK: - Prepare layout
    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()

        let sections = collectionView.numberOfSections
        let items = collectionView.numberOfItems(inSection: 0)

        for section in 0..<sections {
            for item in 0..<items {

                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                var x: CGFloat = 0
                var y: CGFloat = 0
                var width: CGFloat = 0
                var height: CGFloat = 0

                // 🔹 Top-left empty cell
                if section == 0 && item == 0 {
                    width = timeColumnWidth
                    height = headerHeight
                }

                // 🔹 Date header row
                else if section == 0 {
                    x = timeColumnWidth + timeColumnRightSpacing
                        + CGFloat(item - 1) * (cellWidth + cellSpacing)
                    y = 0
                    width = cellWidth
                    height = headerHeight
                }

                // 🔹 Time column
                else if item == 0 {
                    x = 0
                    y = headerHeight + headerBottomSpacing
                        + CGFloat(section - 1) * (cellHeight + cellSpacing)
                    width = timeColumnWidth
                    height = cellHeight
                }

                // 🔹 Booking cells
                else {
                    x = timeColumnWidth + timeColumnRightSpacing
                        + CGFloat(item - 1) * (cellWidth + cellSpacing)

                    y = headerHeight + headerBottomSpacing
                        + CGFloat(section - 1) * (cellHeight + cellSpacing)

                    width = cellWidth
                    height = cellHeight
                }

                attributes.frame = CGRect(x: x, y: y, width: width, height: height)
                cache.append(attributes)
            }
        }

        // MARK: - Content size
        contentSize = CGSize(
            width: timeColumnWidth + timeColumnRightSpacing
                + CGFloat(items - 1) * (cellWidth + cellSpacing),

            height: headerHeight + headerBottomSpacing
                + CGFloat(sections - 1) * (cellHeight + cellSpacing)
        )
    }

    // MARK: - Content size
    override var collectionViewContentSize: CGSize {
        contentSize
    }

    // MARK: - Layout attributes
    override func layoutAttributesForElements(in rect: CGRect)-> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = collectionView else { return cache }

        for attr in cache {
            // Sticky time column
            if attr.indexPath.item == 0 && attr.indexPath.section != 0 {
                attr.frame.origin.x = collectionView.contentOffset.x
                attr.zIndex = 1000
            }
        }
        return cache
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
