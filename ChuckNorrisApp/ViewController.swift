import UIKit

// Define the Chuck Norris Joke structure
struct ChuckNorrisJoke: Codable {
    let value: String
}

class ViewController: UIViewController {
    // I LOVE ANA
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var jokeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jokeLabel.text = ""
        jokeLabel.center = view.center
        jokeButton.setTitle("Generate", for: .normal)
        jokeLabel.numberOfLines = 0
        
        jokeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        jokeButton.backgroundColor = UIColor.blue
        jokeButton.setTitleColor(UIColor.white, for: .normal)
        jokeButton.layer.cornerRadius = 10
        jokeButton.layer.borderColor = UIColor.black.cgColor
        jokeButton.layer.borderWidth = 1
        
        




    }

    @IBAction func fetchJoke(_ sender: UIButton) {
        // Define the Chuck Norris API URL
        let apiUrl = URL(string: "https://api.chucknorris.io/jokes/random")!

        // Fetch the Chuck Norris joke
        if let data = try? Data(contentsOf: apiUrl),
           let joke = try? JSONDecoder().decode(ChuckNorrisJoke.self, from: data) {
            
            // Fade in the joke label with animation
            UIView.animate(withDuration: 0.5, animations: {
                self.jokeLabel.alpha = 0  // Start with zero opacity
                self.jokeLabel.text = joke.value
                self.jokeLabel.alpha = 1  // Fade in to full opacity
            })
        } else {
            jokeLabel.text = "Failed to fetch or parse Chuck Norris joke."
        }
    }
}
