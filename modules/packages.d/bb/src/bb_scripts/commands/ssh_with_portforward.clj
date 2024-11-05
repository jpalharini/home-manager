(ns bb-scripts.commands.ssh-with-portforward
  {:command "sshpf"}
  (:require [babashka.process :as p]
            [clojure.edn :as edn]
            [clojure.string :as str]
            [bb-scripts.entrypoint :as e]))

(defn coerce-forward [s]
  (let [fwd-spec (str/split s #":")]
    (condp = (count fwd-spec)
      1 (let [port (-> fwd-spec (first) (edn/read-string))]
          [port "localhost" port])
      2 (let [[local-port remote-port] (map edn/read-string fwd-spec)]
          [local-port "localhost" remote-port])
      3 (let [[local-port-s remote-host remote-port-s] fwd-spec
              [local-port remote-port] (map edn/read-string [local-port-s remote-port-s])]
          [local-port remote-host remote-port]))))

(def cli-spec
  {:spec       {:destination {:desc    "SSH destination, can be <user@host> or just <host>"
                              :require true}
                :forwards    {:coerce [coerce-forward]
                              :desc   "port mapping - <local-and-remote-port>, <local-port>:<remote-port> <local-port>:<remote-host>:<remote-port>"
                              :alias  :f}
                :background  {:coerce boolean
                              :desc   "Whether to run in background, kills other tunnels to same host in background"
                              :alias  :bg}}
   :args->opts [:destination]})

(defn forwards->command [forwards]
  (->> forwards
       (map (fn [[local-port remote-host remote-port]]
              (format "-L %d:%s:%d "
                      local-port remote-host remote-port)))
       (apply str)))

(defn kill-background-tunnels! [destination]
  (when-let [pids (:out (p/process (format "pgrep -f '^ssh.*%s,bg$'" destination)))]
    (println (format "Found existing tunnel/s to %s, killing process/es..." destination))
    (p/shell {:in pids} "xargs -I % sh -c 'ps -o pid= -o command= % && kill -9 %'")))

(defn run
  [{:keys [destination forwards background]}]
  (when background
    (kill-background-tunnels! destination))
  (let [cmd-str (if background
                  "ssh -fN %1$s%2$s # %2$s,bg"
                  "ssh %1$s%2$s")
        cmd     (format cmd-str
                        (forwards->command forwards) destination)]
    (println "Executing:" cmd)
    (p/shell cmd)))

(defn -main
  [& args]
  (e/-main "sshpf" cli-spec run args))