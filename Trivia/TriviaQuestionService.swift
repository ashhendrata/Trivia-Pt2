//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Ashley Hendrata on 3/16/24.
//

import Foundation

class TriviaQuestionService {
    /*
    static func fetchQuestionSet(type: String,
                                 category: String,
                                 question: String,
                                 correctAnswer: String,
                                 incorrectAnswers: [String]) {
        let url = URL(string: "https://opentdb.com/api.php?amount=10")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let question = parse(data: data)
            DispatchQueue.main.async {
                completion?(response.results)
            }
        }
        task.resume()
    }*/
    static func fetchQuestionSet(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=10")!
        // var request = URLRequest(url: url)
        // request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                completion(nil)
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            let questions = parse(data: data)
            DispatchQueue.main.async {
                completion(questions)
            }
        }
        task.resume()
    }

    
    
    private static func parse(data: Data) -> [TriviaQuestion] {
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let results = jsonDictionary["results"] as! [[String: Any]]
        
        
        var allQuestions = [TriviaQuestion]()
        for result in results {
            guard let type = result["type"] as? String,
                  let category = result["category"] as? String,
                  let question = result["question"] as? String,
                  let correctAnswer = result["correct_answer"] as? String,
                  let incorrectAnswers = result["incorrect_answers"] as? [String] else {
                continue
            }
            let quizQuestion = TriviaQuestion(type: type,
                                              category: category,
                                              question: question,
                                              correctAnswer: correctAnswer,
                                              incorrectAnswers: incorrectAnswers)
            allQuestions.append(quizQuestion)
            
        }
        return allQuestions
    }
}

