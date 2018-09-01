"use strict"

// Assumes 2 arrays as input
const _ = require('lodash')

const LOW_THRESHOLD = 0.7
const HIGH_THRESHOLD = 1.3

module.exports = detectUntrans

function detectUntrans(source, target){
   "use strict"
   var sourceObj = {},
       targetObj = {}

   var sourceText = source.join(" ")
   var targetText = target.join(" ")

   var sourceWords = sourceText.split(" ")
   var targetWords = targetText.split(" ")

   // Remove periods and commas, and get only uniques:
   sourceWords = _.uniq(sourceWords.map(ele=>ele.replace(/[,.]/, "")))
   targetWords = _.uniq(targetWords.map(ele=>ele.replace(/[,.]/, "")))

   // Remove unlikely candidates (TODO: if option 'smart')
   targetWords = targetWords.filter(ele=>{
      return !ele.match(/^[a-z]{0,5}$|^\w{0,2}$/)
   })

   // Count occurrences and log to obj 
   sourceWords.forEach(word=>{
      var re = new RegExp(reEscape(word), 'g')
      if(!sourceObj[word]) sourceObj[word] = 0
      sourceObj[word] += sourceText.match(re).length
   })
   targetWords.forEach(word=>{
      var re = new RegExp(reEscape(word), 'g')
      if(!targetObj[word]) targetObj[word] = 0
      targetObj[word] += targetText.match(re).length
   })

   // Compare frequency of occurrence by percentage:
   sourceWords.forEach(word=>{
      if(!!targetObj[word] && sourceObj[word] !== 0){
         var percentage = targetObj[word] / sourceObj[word]
         if(percentage >= LOW_THRESHOLD
            && percentage <= HIGH_THRESHOLD
            && percentage !== 1)
         {
            // Reformat number
            percentage = percentage * 100
            return `${percentage}%: Source: sourceObj[word] Target: targetHash[word]\t${word}<br>`
         }
      }
   })
}

function reEscape(s) {
   return s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
}
