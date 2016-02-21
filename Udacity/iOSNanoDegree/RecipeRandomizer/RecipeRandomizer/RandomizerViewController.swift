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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        super.viewWillDisappear(animated)
    }
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
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "D'oh!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){action in
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func doSearch(term1: String, term2: String){
        print("Searching for \(term1) and \(term2)")
        let controller = storyboard!.instantiateViewControllerWithIdentifier("RecipeSearchResultsController") as! RecipeSearchResultsController
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
                self.recipes = []
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
                
                if self.recipes.count == 0 {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.showAlert("No recipes found for those search terms")
                    })
                }else{
                    // perfom segue to view results
                    dispatch_async(dispatch_get_main_queue(),{
                        controller.recipes = self.recipes
                        self.navigationController!.pushViewController(controller, animated: true)
                    })
                }
            }else{
                print("meh")
            }
        }

    }
    
    @IBAction func randomSearchPressed(sender: AnyObject) {
        let max = UInt32(DefaultSearchTerms.count)
        let term1:String = DefaultSearchTerms[Int(arc4random_uniform(max))]
        let term2:String = DefaultSearchTerms[Int(arc4random_uniform(max))]
        doSearch(term1, term2: term2)
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        let term1:String = DefaultSearchTerms[self.pickerView1.selectedRowInComponent(0)]
        let term2:String = DefaultSearchTerms[self.pickerView2.selectedRowInComponent(0)]
        doSearch(term1, term2: term2)
    }
}

