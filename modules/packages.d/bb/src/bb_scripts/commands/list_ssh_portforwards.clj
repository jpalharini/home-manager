(ns bb-scripts.commands.list-ssh-portforwards
  {:command "lspf"}
  (:require [babashka.process :as p]
            [clojure.string :as str]
            [bb-scripts.entrypoint :as e]))

(def cli-spec
  {:spec {}})

(defn proc->fwds [proc]
  (str (format "%s\n" proc)
       (->> proc
            (re-seq #"(?:-L )(\d+:.+?:\d+)")
            (map second)
            (map (fn [fwd]
                   (let [[local-port remote-host remote-port] (str/split fwd #":")]
                     (str (format "localhost:%s -> %s:%s\n" local-port remote-host remote-port)))))
            (apply str))))

(defn run
  [_]
  (when-let [procs (-> (p/process "pgrep -fl '^ssh.*-L'") :out (slurp) (str/split-lines))]
    (->> procs
         (map proc->fwds)
         (flatten)
         (run! println))))

(defn -main
  [& args]
  (e/-main "lspf" cli-spec run args))