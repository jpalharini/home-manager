(ns bb-scripts.entrypoint
  (:require [bb-scripts.aux.common :refer :all]
            [babashka.cli :as cli]))

(defn -main [command-name cli-spec run-fn & [args]]
  (let [spec (enrich-spec cli-spec)
        opts (cli/parse-opts args spec)]
    (if (:help opts)
      (println (show-help command-name spec))
      (run-fn opts))))