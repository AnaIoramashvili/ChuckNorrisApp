import UIKit

struct ChuckNorrisJoke: Codable {
    let value: String
}

class ViewController: UIViewController {

    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var jokeButton: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!

    var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCategories()
    }

    func setupUI() {
        // Set up the label
        jokeLabel.numberOfLines = 0
        jokeLabel.textAlignment = .center
        jokeLabel.text = ""

        // Set up the joke button
        jokeButton.layer.cornerRadius = 8
        jokeButton.backgroundColor = UIColor.systemBlue
        jokeButton.setTitleColor(UIColor.white, for: .normal)
        jokeButton.setTitle("Generate", for: .normal)
        

        // Set up the category picker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }

    func fetchCategories() {
        guard let categoriesUrl = URL(string: "https://api.chucknorris.io/jokes/categories") else {
            return
        }

        URLSession.shared.dataTask(with: categoriesUrl) { data, response, error in
            if let data = data {
                do {
                    // Decode the categories from the data
                    let categoriesResponse = try JSONDecoder().decode([String].self, from: data)
                    DispatchQueue.main.async {
                        // Update the categories and reload the picker
                        self.categories = categoriesResponse
                        self.categoryPicker.reloadAllComponents()
                    }
                } catch {
                    print("Error decoding categories: \(error)")
                }
            }
        }.resume()
    }

    @IBAction func fetchJoke(_ sender: UIButton) {
        // Get the selected category from the picker
        let selectedCategory = categories[safe: categoryPicker.selectedRow(inComponent: 0)] ?? ""

        // Build the URL for fetching a random joke from the selected category
        let apiUrlString = "https://api.chucknorris.io/jokes/random?category=\(selectedCategory)"
        guard let apiUrl = URL(string: apiUrlString) else {
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            if let data = data {
                do {
                    // Decode the joke from the data
                    let joke = try JSONDecoder().decode(ChuckNorrisJoke.self, from: data)
                    DispatchQueue.main.async {
                        // Display the joke with a fade-in animation
                        UIView.animate(withDuration: 0.5) {
                            self.jokeLabel.alpha = 0
                            self.jokeLabel.text = joke.value
                            self.jokeLabel.alpha = 1
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.jokeLabel.text = "Failed to fetch or parse Chuck Norris joke."
                    }
                }
            }
        }.resume()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // You can add further actions here if needed
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
