import UIKit

class DetailViewController: UITableViewController{
    
    var category: Category!
    let dateFormatter = DateFormatter()
    
    
    var subcategories: [(String, [String])] = [("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"])]
 
    override func viewDidLoad() {
        tableView.delegate = self
        title = category.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return category.subcategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.subcategories[section].transactions.count + 1
    }
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomHeaderCell
//        cell.subcategoryName.text = subcategories[section].0
//        return cell
//    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0){
            return 40.0
        }
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CustomFooterCell
//        cell.subcategoryName.text = subcategories[section].0
//        cell.subcategoryTotal.text = "€\(120)"
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if indexPath.row == (category.subcategories[indexPath.section].transactions.count - 1) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
            cell.itemName.text = "\(dateFormatter.string(from: category.subcategories[indexPath.section].transactions[indexPath.row].date))"
            cell.itemPrice.text = "€\(category.subcategories[indexPath.section].transactions[indexPath.row].amount)"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CustomFooterCell
            cell.subcategoryName.text = category.subcategories[indexPath.section].name
            cell.subcategoryTotal.text = "€\(category.subcategories[indexPath.section].transactions[indexPath.row-1].amount)"
            return cell
        }
    }
    
}