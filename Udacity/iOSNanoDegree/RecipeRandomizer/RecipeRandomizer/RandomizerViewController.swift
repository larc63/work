//
//  RandomizerViewController
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/17/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class RandomizerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var recipes:[Recipe] = []
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 18
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DefaultSearchTerms[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //MARK: UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DefaultSearchTerms.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func searchButtonPressed(sender: AnyObject) {
        let term1:String = DefaultSearchTerms[self.pickerView1.selectedRowInComponent(0)]
        let term2:String = DefaultSearchTerms[self.pickerView2.selectedRowInComponent(0)]
        print("Searching for \(term1) and \(term2)")
        Food2ForkClient.sharedInstance().getRecipesForSearchTerms([term1, term2]) { (success, errorString, recipeData) -> Void in
            if success {
                
                //"publisher": "My Baking Addiction",
                //"f2f_url": "http://food2fork.com/view/e7fdb2",
                //"title": "Mac and Cheese with Roasted Chicken, Goat Cheese, and Rosemary",
                //"source_url": "http://www.mybakingaddiction.com/mac-and-cheese-roasted-chicken-and-goat-cheese/",
                //"recipe_id": "e7fdb2",
                //"image_url": "http://static.food2fork.com/MacandCheese1122b.jpg",
                //"social_rank": 100.0,
                //"publisher_url": "http://www.mybakingaddiction.com"
                for recipe in recipeData!{
                    let id = recipe["recipe_id"] as! String
                    let title = recipe["title"] as! String
                    let source_url = recipe["source_url"] as! String
                    let image_url = recipe["image_url"] as! String
                    let publisher = recipe["publisher"] as! String
                    let dictionary: [String : AnyObject] = [
                        RecipeKeys.ID : id,
                        RecipeKeys.TITLE : title,
                        RecipeKeys.SOURCE_URL : source_url,
                        RecipeKeys.IMAGE_URL : image_url,
                        RecipeKeys.PUBLISHER : publisher
                    ]
                    let recipeToAdd = Recipe(dictionary: dictionary)
                    self.recipes.append(recipeToAdd)
                }
                // perfom segue to view results
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RecipeSearchResultsController") as! RecipeSearchResultsController
                controller.recipes = self.recipes
                self.navigationController!.pushViewController(controller, animated: true)
            }else{
                print("meh")
            }
        }
    }
}

