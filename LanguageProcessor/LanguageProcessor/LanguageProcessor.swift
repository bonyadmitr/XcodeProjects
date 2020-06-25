import NaturalLanguage

/// article https://www.andyibanez.com/posts/analyzing-text-nltagger/
/// article https://medium.com/better-programming/analyse-users-language-in-swift-43e3041c521f
final class LanguageProcessor {
    
    func getVerbs(from stringToRecognize: String) -> [String] {
        var verbsArray: [String] = []
        let range = stringToRecognize.startIndex ..< stringToRecognize.endIndex
        
        let scheme = NLTagScheme.lexicalClass
        let tagger = NLTagger(tagSchemes: [scheme])
        
        tagger.string = stringToRecognize
        tagger.enumerateTags(in: range,
                             unit: .word,
                             scheme: scheme,
                             options: [.omitPunctuation, .omitWhitespace, .joinNames]) { tag, range in
                                
                                if let tag = tag {
                                    print("Word \"\(stringToRecognize[range])\" - \(tag.rawValue)")
                                }
                                
                                
                                if tag?.rawValue == "Verb" {
                                    verbsArray.append(String(stringToRecognize[range]))
                                }
                                
                                return true
        }
        
        return verbsArray
    }
    
    func getSentimentScore(from stringToRecognize: String, sentimentScore: @escaping (Double) -> Void) {
        DispatchQueue.global().async {
            let range = stringToRecognize.startIndex ..< stringToRecognize.endIndex
            
            let scheme = NLTagScheme.sentimentScore
            let tagger = NLTagger(tagSchemes: [scheme])
            
            tagger.string = stringToRecognize
            tagger.enumerateTags(in: range,
                                 unit: .paragraph,
                                 scheme: scheme,
                                 options: [.omitWhitespace]) { tag, range in
                                    
                                    if let tag = tag, let score = Double(tag.rawValue) {
                                        sentimentScore(score)
                                    } else {
                                        sentimentScore(0)
                                    }
                                    return true
            }
        }
        
        
    }
    
}
