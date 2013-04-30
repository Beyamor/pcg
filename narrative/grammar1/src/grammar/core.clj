(ns grammar.core)

(defprotocol LHS
  (=> [this rules] "Returns a vector of terminal elements according to the provided rules."))

(extend-protocol LHS

  ; Simply returns a singleton vector containing itself
  String
    (=> [this _] [this])

  ; Returns the transformation of a random element
  clojure.lang.IPersistentSet
    (=> [this rules]
      (let [some-element (-> this vec rand-nth)]
        (=> some-element rules)))

  ; Returns the transformation of its contents
  clojure.lang.Sequential
    (=> [this rules]
      (mapcat #(=> % rules) this))

  ; Returns the transformation of whatever the rules describe
  clojure.lang.Keyword
    (=> [this rules]
      (=> (get rules this) rules))

  ; Calls itself and transforms the result
  clojure.lang.IFn
    (=> [this rules]
      (=> (this) rules)))

(defn generate
  [rules initial-sentence]
  (mapcat #(=> % rules) initial-sentence))

(def small-number #{"one" "two" "three" "four" "five" "six"})

(def rules
  {
   :start
   ["Your story begins. " :starting-point :first-goal]

   :starting-point
   #{"You wake up. "
     "Your father dies. "}

   :first-goal
   #{"Reach the village. "}

   :middle
   #(take (+ 1 (rand-int 3)) (repeat :plot-point))

   :plot-point
   #{"Find the island. "
     "Find the sage. "
     ["Cross the " #{"desert", "forest", "volcano"} ". "]
     ["Find the " small-number " " #{"keys", "orbs", "mages"} ". "]}

   :final-battle
   ["You defeat the " #{"wizard", "dragon", "witch", "sorcerer"} ". "]

   :goal
   ["You save the " #{"prince", "princess", "world", "kingdom"} "! "]

   :end
   [:final-battle :goal "Your story ends."]
  })
