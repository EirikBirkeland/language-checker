var untrans = require('./detect_untrans.js')

var arr1 = ["I am a dog", "my dog is good", "great is my dog"] 
var arr2 = ["Jeg er en hund", "min hund er god", "flott er min bikkje"]

console.log(untrans(arr1,arr2))
