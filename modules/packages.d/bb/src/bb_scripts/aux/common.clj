(ns bb-scripts.aux.common
  (:require [babashka.cli :as cli]))

(defn arg->help [arg]
  (str "<" (name arg) "> "))

(def help-opt {:coerce :boolean
               :desc   "show this help message"
               :alias  :h})

(defn handle-error [{:keys [spec type cause msg option] :as data}]
  (when (= :org.babashka/cli type)
    (case cause
      :require (println (format "Missing required argument: %s\n" option)))))

(defn enrich-spec [spec]
  (-> spec
      (assoc-in [:spec :help] help-opt)
      (assoc :error-fn handle-error)))

(defn show-help [command-name {:keys [args->opts spec] :as fspec}]
  (let [opts-spec (assoc fspec :spec (apply dissoc spec args->opts))]
    (str "Usage:\n"
         command-name " " (when args->opts (apply arg->help args->opts)) "[options]" "\n\n"
         "Options:\n"
         (cli/format-opts (merge opts-spec {:order (vec (keys (:spec opts-spec)))})))))