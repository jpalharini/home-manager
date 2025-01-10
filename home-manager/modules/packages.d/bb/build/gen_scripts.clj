(ns gen-scripts
  (:require [clojure.java.io :as io]
            [clojure.string :as str]))

(defn load-commands []
  (->> (file-seq (io/file "src/bb_scripts/commands"))
       (filter #(.isFile %))
       (map #(.getPath %))
       (mapv load-file)))

(defn list-commands []
  (->> (all-ns)
       (filter #(str/starts-with? (ns-name %) "bb-scripts.commands"))))

(defn generate-script [ns]
  (let [{:keys [command]} (meta ns)]
    (spit (str "out/" command)
          (str
           "#! /usr/bin/env bash"
           "\n\n"
           (format "bb --classpath ~/.bin/bb/src -m %s/-main \"$@\"" (ns-name ns))))))

(defn -main [& args]
  (load-commands)
  (->> (list-commands)
       (map generate-script)
       (doall)))