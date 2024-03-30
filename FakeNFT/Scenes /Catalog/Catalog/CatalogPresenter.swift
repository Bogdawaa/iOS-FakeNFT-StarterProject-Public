import UIKit

protocol CatalogPresenter: CatalogViewDelegate {
    var delegate: CatalogPresenterDelegate? { get set }

}

protocol CatalogPresenterDelegate: AnyObject {
    func didSelectRow(rowData: CatalogRowData)
}

let url = URL(string: "https://s3-alpha-sig.figma.com/img/727b/b319/2163ae99ca0449e797b557a9d12b3f70" +
    "?Expires=1712534400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4" +
    "&Signature=CvoEf-UVltlevpiOVf1Z7-QKxbn6MJGv35SCWhRHe6lO7z1D2II0Lrxh" +
    "yo2i-NkabEE57Os~UDqdT0d0Q47Lgno0~M2S4QkKP4dHb8BSA1190rWke7r3vCac" +
    "Ye8hbsAPl0wFSIMXZoaNpzI1f4CsBV0f3kg9msNnc9AizUoBtsMQbzqN24l40Pl6Oc-" +
    "YErDDzfofztwFlReXiQIEJ2-wBi0deQz4hB7AdBuFNdZw64N73kfLYfW5nQcJkH4ozS1Nh" +
    "6j294WFpSFY4ovOD4vzni-pgBWVuESfygrTVYZx4~K~6RSN42DQXjwYwt1JjCFiPrBAtG2dBomPgpFnoShzoQ__"
)!

final class CatalogPresenterImpl: CatalogPresenter {
    weak var delegate: CatalogPresenterDelegate?

    private var catalogRows: [CatalogRowData] = [
        CatalogRowData(imageURL: url, name: "Name1", nftCount: 10),
        CatalogRowData(imageURL: url, name: "Name2", nftCount: 11),
        CatalogRowData(imageURL: url, name: "Name3", nftCount: 12),
        CatalogRowData(imageURL: url, name: "Name4", nftCount: 13),
        CatalogRowData(imageURL: url, name: "Name5", nftCount: 14),
        CatalogRowData(imageURL: url, name: "Name6", nftCount: 15)
    ]
}

extension CatalogPresenterImpl: CatalogViewDelegate {
    var numberOfRows: Int {
        catalogRows.count
    }

    func rowData(at indexPath: IndexPath) -> CatalogRowData? {
        catalogRows[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let rowData = rowData(at: indexPath) else { return }
        delegate?.didSelectRow(rowData: rowData)
    }
}

struct CatalogRowData {
    let imageURL: URL
    let name: String
    let nftCount: Int
}
